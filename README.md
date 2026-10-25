# CYBER-CORP TAKEOVER

Flutter Web PWA — Night City Monopoly-style board game.

- **GitHub:** https://github.com/stasusss/monopoly-cyber-corp
- **Live (Vercel):** https://web-eight-jet-29.vercel.app

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

1. Vercel → Account Settings → Tokens (create token).
2. Project Settings → General → copy **Project ID**; Team/Account → **Org ID**.
3. GitHub repo → Settings → Secrets → Actions:
   - `VERCEL_TOKEN`
   - `VERCEL_ORG_ID` = `team_na0SQbn2OUljLR6qt1XaDySJ`
   - `VERCEL_PROJECT_ID` = `prj_jqNjGSeJz62qsnEvrcHqy59Y1rGj`
4. Push to `main` — workflow `.github/workflows/deploy_to_vercel.yml` builds & deploys.
