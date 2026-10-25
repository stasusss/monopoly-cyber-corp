# CYBER-CORP TAKEOVER

Flutter Web PWA — Night City Monopoly-style board game.

## Local run

```bash
flutter pub get
flutter run -d chrome --web-port=3000
```

## Release build

```bash
flutter build web --release
```

Output: `build/web`

## Deploy (Vercel)

### Option A — CLI (fast)

```bash
flutter build web --release
npx vercel deploy build/web --prod --yes
```

### Option B — GitHub Actions

1. Create a Vercel project and copy **Token**, **Org ID**, **Project ID**.
2. Add GitHub secrets: `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`.
3. Push to `main` — workflow `.github/workflows/deploy_to_vercel.yml` builds & deploys.
