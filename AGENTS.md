# AGENTS.md

This file is the single operating guide for coding agents in this repository.
Goal: maximize correctness with minimum token usage.

## 1) Project Snapshot

Monorepo with 6 active packages:
- `packages/backend`: Kotlin/Ktor API (Gradle, GraalVM native build, Liquibase).
- `packages/frontend`: Preact + TypeScript + Vite (Bun, ESLint).
- `packages/app`: Flutter Android app (BLoC, freezed/json_serializable/auto_route generated files committed).
- `packages/infrastructure`: Terraform (`k8s`, `aws`, `init_backend`).
- `packages/doc`: Docusaurus documentation.
- `packages/tools/reflect-merger`: TypeScript utility.

Root docs/config worth reading first:
- `README.md`
- `CLAUDE.md`
- `design-system.md`
- `.github/workflows/*.yml`

## 2) Token-Efficient Workflow (Mandatory)

1. Route to one package first. Do not scan entire repo unless explicitly requested.
2. Read only:
- this file,
- target package manifest/build file,
- directly impacted files.
3. Prefer narrow search commands:
- `rg "<pattern>" <package-path>`
- `rg --files <package-path>`
4. Run minimal validation matching changed area (see section 6).
5. In final report, list only touched files + commands run + result.

## 3) Hard Ignore Paths (Do Not Read Unless Explicitly Required)

- `**/node_modules/**`
- `**/build/**`
- `**/.gradle/**`
- `**/.dart_tool/**`
- `**/.terraform/**`
- `**/dist/**`
- `**/.idea/**`
- `**/.vscode/**`
- `**/.git/**`

Also avoid binary/media inspection unless task needs it:
- `**/*.png`, `**/*.jpg`, `**/*.webp`, `**/*.svg`, `**/*.jar`

## 4) Generated Files Policy

Never hand-edit generated files unless user explicitly asks.

Flutter generated files (committed):
- `packages/app/lib/**/*.g.dart`
- `packages/app/lib/**/*.freezed.dart`
- `packages/app/lib/**/*.gr.dart`

Regenerate with:
- `cd packages/app`
- `dart run build_runner build --delete-conflicting-outputs`

Backend native-image generated configs (usually generated/merged):
- `packages/backend/src/main/resources/jni-config.json`
- `packages/backend/src/main/resources/proxy-config.json`
- `packages/backend/src/main/resources/resource-config.json`
- `packages/backend/processor/src/main/resources/reflect-config-sample.json`

## 5) Task Routing

### Backend (`packages/backend`)
Use for API, DB, auth, websocket, mail, Ktor, Liquibase, native build.

Read first:
- `packages/backend/build.gradle.kts`
- `packages/backend/gradle.properties`
- `packages/backend/src/main/resources/liquibase-changelog.sql`

Key commands:
Do not any commands for backend.

DB convention reminders:
- Liquibase changelog is SQL only: `packages/backend/src/main/resources/liquibase-changelog.sql`
- Keep `--changeset author:id [context:...]` format.

### Frontend (`packages/frontend`)
Use for back-office web UI.

Read first:
- `packages/frontend/package.json`
- `packages/frontend/eslint.config.js`
- `packages/frontend/src/config/backendBaseUrl.ts`
- `design-system.md` (for style consistency)

Key commands:
- `cd packages/frontend && bun install --frozen-lockfile`
- `cd packages/frontend && bun run lint`
- `cd packages/frontend && bun run build`
- `cd packages/frontend && bun run dev`

Env commonly needed:
- `VITE_BACKEND_BASE_URL`
- `VITE_MAPBOX_KEY`

### Mobile App (`packages/app`)
Use for Flutter Android app.

Read first:
- `packages/app/pubspec.yaml`
- `packages/app/analysis_options.yaml`
- `packages/app/lib/app/app_router.dart`

Key commands:
- `cd packages/app && flutter pub get`
- `cd packages/app && flutter test`
- `cd packages/app && flutter analyze`
- `cd packages/app && dart run build_runner build --delete-conflicting-outputs` (only when needed)

### Infrastructure (`packages/infrastructure`)
Use for Terraform.

Scope:
- Active CI deploy target is `packages/infrastructure/k8s`.
- `aws` and `init_backend` are separate Terraform projects.

Key commands:
- `cd packages/infrastructure/k8s && terraform fmt -check -recursive`
- `cd packages/infrastructure/k8s && terraform validate`

Never run `terraform apply` unless explicitly requested.

### Docs (`packages/doc`)
Use for Docusaurus docs.

Key commands:
- `cd packages/doc && npm ci`
- `cd packages/doc && npm run build`
- `cd packages/doc && npm run start`

### Tools (`packages/tools/reflect-merger`)
Use for reflect config merge utility.

Key commands:
- `cd packages/tools/reflect-merger && npm ci`
- `cd packages/tools/reflect-merger && npm run start -- <jsonA> <jsonB>`

## 6) Minimal Validation Matrix

Run only what matches touched area:

- Frontend TS/TSX/CSS:
- `cd packages/frontend && bun run lint`
- `cd packages/frontend && bun run build` (if behavior or types changed)

- Flutter Dart:
- `cd packages/app && flutter test`
- `cd packages/app && flutter analyze` (recommended for non-trivial changes)

- Terraform:
- `cd packages/infrastructure/<project> && terraform fmt -check -recursive`
- `cd packages/infrastructure/<project> && terraform validate`

- Docs:
- `cd packages/doc && npm run build`

If any required tool is missing locally, state it explicitly.

## 7) CI Parity Notes

To stay aligned with GitHub Actions:
- Frontend CI runs `bun run lint` then `bun run build` with Mapbox/backend envs.
- App CI runs `flutter test`.
- Infra CI runs `terraform fmt`, `init`, `validate`, then plan/apply in workflow context.

## 8) Output Format for Agent Responses

Keep responses concise and deterministic:
1. What changed.
2. Files changed.
3. Commands run + pass/fail.
4. Any blockers or assumptions.

Avoid long narrative and avoid quoting large file contents unless requested.
