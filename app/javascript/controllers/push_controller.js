import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  async connect() {
    if (!('serviceWorker' in navigator && 'PushManager' in window)) return

    try {
      const registration = await navigator.serviceWorker.register('/service-worker.js')

      // Wait for the service worker to be ready
      await navigator.serviceWorker.ready

      // Check for existing subscription
      let subscription = await registration.pushManager.getSubscription()

      // Validate existing subscription matches current VAPID key
      // If keys changed, the old subscription is useless — unsubscribe
      if (subscription) {
        const currentKey = this.vapidKey()
        const existingKey = new Uint8Array(subscription.options.applicationServerKey)

        if (!this.arraysEqual(currentKey, existingKey)) {
          console.log("VAPID key changed, re-subscribing...")
          await subscription.unsubscribe()
          subscription = null
        }
      }

      // Subscribe if needed
      if (!subscription) {
        subscription = await registration.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: this.vapidKey()
        })
      }

      // Send subscription to server
      await fetch('/push_subscriptions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify(subscription),
        credentials: 'same-origin'
      })

    } catch (error) {
      console.error("Push subscription failed:", error)
    }
  }

  vapidKey() {
    const key = document.querySelector('meta[name="vapid-public-key"]').content
    return this.urlBase64ToUint8Array(key)
  }

  urlBase64ToUint8Array(base64String) {
    const padding = '='.repeat((4 - base64String.length % 4) % 4)
    const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/')
    const rawData = atob(base64)
    return Uint8Array.from([...rawData].map(c => c.charCodeAt(0)))
  }

  arraysEqual(a, b) {
    if (a.length !== b.length) return false
    for (let i = 0; i < a.length; i++) {
      if (a[i] !== b[i]) return false
    }
    return true
  }
}