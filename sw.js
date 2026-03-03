const CACHE_NAME = 'contractor-dir-v2';
const ASSETS = ['./index.html', './manifest.json', './icon-192.png', './icon-512.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE_NAME).then(c => c.addAll(ASSETS)));
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys =>
    Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
  ));
  self.clients.claim();
});

self.addEventListener('fetch', e => {
  if (e.request.url.includes('cdnjs.cloudflare.com') || e.request.url.includes('fonts.googleapis.com') || e.request.url.includes('fonts.gstatic.com')) {
    e.respondWith(caches.open(CACHE_NAME).then(cache =>
      cache.match(e.request).then(r => r || fetch(e.request).then(resp => { cache.put(e.request, resp.clone()); return resp; }))
    ));
    return;
  }
  e.respondWith(caches.match(e.request).then(r => r || fetch(e.request)));
});
