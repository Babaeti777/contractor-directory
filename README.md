# 1 Oak Builders — Contractor Directory

A mobile-first Progressive Web App for managing your contractor contacts. Upload business card photos, store company info, search & filter your network — all from your phone.

## Features

- **Camera / Photo Upload** — Snap business cards directly or upload from your gallery
- **Search & Filter** — Find contractors by name, service, tag, or location
- **Star Ratings & Notes** — Rate and annotate each contractor
- **Tags** — Add custom tags for easy categorization
- **Export / Import** — Back up as CSV or JSON, restore anytime
- **Works Offline** — Installable as a mobile app (PWA)
- **No Server Needed** — All data stays in your browser (IndexedDB)

## Deploy to GitHub Pages

### Quick Setup (5 minutes)

1. **Create a new GitHub repository**
   - Go to [github.com/new](https://github.com/new)
   - Name it `contractor-directory` (or anything you like)
   - Set it to **Public**
   - Click **Create repository**

2. **Upload the files**
   - On the repo page, click **"uploading an existing file"** link
   - Drag ALL 5 files from this folder into the upload area:
     - `index.html`
     - `manifest.json`
     - `sw.js`
     - `icon-192.png`
     - `icon-512.png`
   - Click **Commit changes**

3. **Enable GitHub Pages**
   - Go to **Settings** → **Pages** (in left sidebar)
   - Under "Source", select **Deploy from a branch**
   - Branch: **main**, Folder: **/ (root)**
   - Click **Save**

4. **Access your app**
   - Wait 1-2 minutes for deployment
   - Your app will be live at: `https://YOUR-USERNAME.github.io/contractor-directory/`

### Install on Your Phone

1. Open the URL in Chrome (Android) or Safari (iPhone)
2. **Android**: Tap the menu (⋮) → "Add to Home screen"
3. **iPhone**: Tap Share (↑) → "Add to Home Screen"

Now it works just like a native app — even offline!

## Data Storage

All your data is stored locally in your browser using IndexedDB. This means:
- Your data never leaves your device
- It persists between sessions
- **Use Export (JSON) regularly to back up your data**
- If you clear browser data, you'll lose your entries (import from backup to restore)
