const CACHE_NAME = "perkup-v3";
const OFFLINE_URL = "/offline.html";

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll([
        "/",
        OFFLINE_URL
      ]);
    })
  );
});

self.addEventListener("fetch", event => {
  event.respondWith(
    fetch(event.request).catch(() => {
      return caches.match(OFFLINE_URL);
    })
  );
});

self.addEventListener("push", event => {
  let data = {};
  try {
    data = event.data ? event.data.json() : {};
  } catch (_e) {
    data = { title: "PerkUp", body: event.data ? event.data.text() : "" };
  }

  const title = data.title || "PerkUp";
  const options = {
    body: data.body || "",
    icon: data.icon || "/coffee.png",
    badge: data.badge || "/coffee.png",
    data: { url: data.url || "/" }
  };

  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener("notificationclick", event => {
  event.notification.close();
  const url = (event.notification.data && event.notification.data.url) || "/";
  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true }).then(list => {
      for (const client of list) {
        if (new URL(client.url).pathname === url && "focus" in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) return clients.openWindow(url);
    })
  );
});
