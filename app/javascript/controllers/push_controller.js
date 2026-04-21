import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  async connect() {
    if (!("serviceWorker" in navigator) || !("PushManager" in window)) return

    const meta = document.querySelector('meta[name="vapid-public-key"]')
    if (!meta || !meta.content) return
    const vapidKey = this.urlBase64ToUint8Array(meta.content)

    try {
      const registration = await navigator.serviceWorker.ready

      let permission = Notification.permission
      if (permission === "default") {
        permission = await Notification.requestPermission()
      }
      if (permission !== "granted") return

      let subscription = await registration.pushManager.getSubscription()

      if (subscription) {
        const existing = new Uint8Array(subscription.options.applicationServerKey)
        if (!this.sameKey(existing, vapidKey)) {
          await subscription.unsubscribe()
          subscription = null
        }
      }

      if (!subscription) {
        subscription = await registration.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: vapidKey
        })
      }

      const token = document.querySelector('meta[name="csrf-token"]')?.content
      await fetch("/push_subscriptions", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token || ""
        },
        credentials: "same-origin",
        body: JSON.stringify(subscription)
      })
    } catch (err) {
      console.error("Push subscription failed:", err)
    }
  }

  urlBase64ToUint8Array(base64String) {
    const padding = "=".repeat((4 - base64String.length % 4) % 4)
    const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/")
    const raw = atob(base64)
    return Uint8Array.from([...raw].map(c => c.charCodeAt(0)))
  }

  sameKey(a, b) {
    if (a.length !== b.length) return false
    for (let i = 0; i < a.length; i++) if (a[i] !== b[i]) return false
    return true
  }
}
