const CACHE_NAME = 'contractor-dir-v3';
const LOCAL_ASSETS = ['./', './index.html', './manifest.json', './icon-192.png', './icon-512.png'];
const CDN_ASSETS = [
  'https://cdnjs.cloudflare.com/ajax/libs/react/18.2.0/umd/react.production.min.js',
  'https://cdnjs.cloudflare.com/ajax/libs/react-dom/18.2.0/umd/react-dom.production.min.js',
  'https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/7.23.9/babel.min.js',
  'https://cdn.jsdelivr.net/npm/tesseract.js@5/dist/tesseract.min.js'
];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE_NAME).then(async cache => {
      await cache.addAll(LOCAL_ASSETS);
      // Cache CDN assets separately (don't fail install if CDN is down)
      for (const url of CDN_ASSETS) {
        try { await cache.add(url); } catch (err) { console.warn('CDN cache miss:', url); }
      }
    })
  );
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys =>
    Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
  ));
  self.clients.claim();
});

self.addEventListener('fetch', e => {
  // CDN resources: cache-first, then network
  if (e.request.url.includes('cdnjs.cloudflare.com') || e.request.url.includes('fonts.googleapis.com') || e.request.url.includes('fonts.gstatic.com')) {
    e.respondWith(
      caches.open(CACHE_NAME).then(cache =>
        cache.match(e.request).then(r => r || fetch(e.request).then(resp => {
          cache.put(e.request, resp.clone());
          return resp;
        }))
      ).catch(() => new Response('', { status: 503, statusText: 'Offline' }))
    );
    return;
  }
  // Local resources: network-first, fall back to cache (ensures updates are picked up)
  e.respondWith(
    fetch(e.request).then(resp => {
      const clone = resp.clone();
      caches.open(CACHE_NAME).then(cache => cache.put(e.request, clone));
      return resp;
    }).catch(() => caches.match(e.request))
  );
});
