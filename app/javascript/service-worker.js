importScripts("https://cdn.onesignal.com/sdks/web/v16/OneSignalSDK.sw.js");
const CACHE_NAME = "perkup-v2";
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
