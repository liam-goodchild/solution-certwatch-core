# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

CertWatch — tracks IT certification expiry dates (Microsoft, AWS, CompTIA). React SPA + Azure Static Web Apps managed Functions API + a separate timer-triggered jobs Function App.

## Repo Layout

```
frontend/         React + Vite + TypeScript SPA
functions/api/    SWA-managed Azure Functions API (Node 20, v4 model)
functions/jobs/   Standalone Function App for timer jobs (dailyReminder)
infra/            Terraform — Azure + Cloudflare DNS
```

## Commands

### Frontend (`frontend/`)
```bash
npm run dev       # Vite dev server
npm run build     # tsc + vite build → dist/
npm run lint      # ESLint
```

### API (`functions/api/`)
```bash
npm ci
npm run build     # tsc → dist/
npm start         # build + func start (requires Azure Functions Core Tools)
npm test          # jest
```

### Jobs (`functions/jobs/`)
```bash
npm ci
npm start         # build + func start
```

### Terraform (`infra/`)
```bash
terraform -chdir=infra init
terraform -chdir=infra plan -var-file="vars/globals.tfvars" -var-file="vars/prd.tfvars"
terraform -chdir=infra apply -auto-approve -var-file="vars/globals.tfvars" -var-file="vars/prd.tfvars"
```

## Architecture

### Auth
SWA handles Entra ID (AAD) auth. All `/api/*` routes require the `authenticated` role (`staticwebapp.config.json`). Functions receive the caller identity via the `x-ms-client-principal` header, decoded in `functions/api/src/shared/auth/validateToken.ts`. No JWT validation in code — SWA validates tokens before forwarding.

### Data
Cosmos DB (`certwatch` database) with three containers: `users`, `certifications`, `reminderLogs`. Client singleton in `shared/db/cosmosClient.ts` reads `COSMOS_ENDPOINT` / `COSMOS_KEY` / `COSMOS_DATABASE` env vars.

### Provider system
`functions/api/src/shared/providers/` — `base.ts` defines `ICertificationProvider`. Microsoft, AWS, CompTIA providers registered at startup in `src/index.ts` via `providerRegistry`. The `sync` function calls the appropriate provider to refresh cert data.

### Jobs vs API
`functions/jobs/` duplicates shared code from `functions/api/src/shared/` (cosmosClient, models, emailService) — they are **separate deployments**, not shared packages. The jobs app runs on a standalone Flex Consumption Function App; the API runs as SWA managed functions.

### CI/CD
- `swa.yml` — deploys SWA + API on push to `major/**`, `minor/**`, `patch/**` when `frontend/**` or `functions/**` change. Fetches deployment token from Azure at runtime (no stored secret).
- `terraform.yml` — plan/apply/destroy on `infra/**` changes. Remote state in platform subscription storage account `sttfsplatform{env}uks01`.
- `linting.yml` — runs ESLint, stylelint, tflint, checkov, zizmor across the repo.

### Local API dev
Copy `functions/api/local.settings.json` and replace `REPLACE_ME` placeholders with real endpoints. `COSMOS_KEY` is not in the template — add it manually or use `DefaultAzureCredential` if RBAC is configured.
