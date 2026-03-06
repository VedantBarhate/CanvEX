# CanvEx

**Turn Gemini Canvas-generated React apps into native Windows desktop executables — no setup, no configuration, no Electron knowledge required.**

---

## What is CanvEx?

Gemini Canvas can generate polished, interactive React dashboards and tools in seconds. But they're browser-bound — you can't ship them, hand them off, or run them offline.

CanvEx bridges that gap. Drop your Canvas-generated `App.jsx` into a Docker container and get a ready-to-run `.exe` out. That's it.

---

## Quick Start

```bash
# Pull the image
docker pull vedantbarhate/canvex:v1.2

# Run the pipeline
docker run --rm \
  -v "/path/to/your/App.jsx:/input/App.jsx" \
  -v "/path/to/output:/output" \
  -e APP_NAME="MyApp" \
  vedantbarhate/canvex:v1.2
```

Your `.exe` will appear in the output folder.

---

## How It Works

1. Copy your React code from Gemini Canvas and save it as `App.jsx`
2. Mount it into the container via `-v`
3. CanvEx scaffolds a minimal Electron wrapper around it
4. Detects and installs any dependencies your code needs
5. Builds and packages a portable Windows executable

---

## Options

| Variable | Default | Description |
|---|---|---|
| `APP_NAME` | `CanvEx.App` | Name of the output application |

---

## Requirements

- Docker installed and running
- A valid `App.jsx` from Gemini Canvas (default React export)

---

## Project Structure (Internal)

```
canvex/
├── scaffold/               # Pre-built Electron + React + Tailwind template
│   ├── scripts/
│   │   └── install-missing-deps.js   # Auto-detects imports from App.jsx
│   ├── src/
│   ├── main.js
│   ├── package.json
│   └── vite.config.js
├── Dockerfile
└── entrypoint.sh           # Build pipeline script
```

---

## Roadmap

| Phase | Status | Description |
|---|---|---|
| Phase 1 | ✅ Done | Electron-based pipeline, Windows `.exe` output |
| Phase 2 | 🔜 Planned | Tauri-based pipeline — smaller binaries, true cross-platform (`.exe`, `.AppImage`, `.dmg`) |

---

## Limitations (Phase 1)

- Windows output only (`.exe` portable)
- Happy path only — heavily customized Canvas code may need manual tweaks
- Canvas code must use a default export React component

---

## Built By

[Vedant Barhate](https://github.com/VedantBarhate)

[Vedant Barhate LinkedIn](www.linkedin.com/in/vedant-barhate-63b94025a)

---

> CanvEx is not affiliated with Google or Gemini. It is an independent open-source tool.