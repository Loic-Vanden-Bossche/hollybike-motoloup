# AGENTS.md

This is the operating guide for coding agents in this repository.
Primary objective: **high-confidence changes with minimal scope and minimal token use**.

## 1) Repository Snapshot (authoritative)

This is a **Moonrepo-managed monorepo** (`@moonrepo/cli` at root), with 4 active projects:

- `packages/backend` — Kotlin/Ktor API (Gradle, Liquibase SQL changelog, GraalVM native-image pipeline)
- `packages/frontend` — Preact + TypeScript + Vite (Bun)
- `packages/app` — Flutter Android app (BLoC + AutoRoute + freezed/json_serializable generated code committed)
- `packages/infrastructure` — Terraform projects (`k8s`, `aws`, `init_backend`)

Moon project mapping is defined in `.moon/workspace.yml`.

## 2) Monorepo Execution Model

Prefer **Moon tasks** for consistency with CI:

- `bunx @moonrepo/cli run <project>:<task>`
- `bunx @moonrepo/cli projects`
- `bunx @moonrepo/cli tasks`

Root toolchain and automation:

- Bun + Node (root `package.json`)
- Husky + lint-staged + commitlint
- GitHub Actions workflows in `.github/workflows/`

## 3) Mandatory Token-Efficient Workflow

1. Route to **one package first**.
2. Read only:
   - this file,
   - root files required for the task,
   - target package manifest/build file,
   - directly impacted files.
3. Use narrow search:
   - `rg "<pattern>" <package-path>`
   - `rg --files <package-path>`
4. Run minimal validation for touched area only (section 8).
5. In your final response, include only:
   - what changed,
   - files changed,
   - commands run + pass/fail,
   - blockers/assumptions.

## 4) Hard Ignore Paths (unless explicitly requested)

- `**/node_modules/**`
- `**/build/**`
- `**/.gradle/**`
- `**/.dart_tool/**`
- `**/.terraform/**`
- `**/dist/**`
- `**/.idea/**`
- `**/.vscode/**`
- `**/.git/**`

Avoid binary/media inspection unless task requires it:
- `**/*.png`, `**/*.jpg`, `**/*.webp`, `**/*.svg`, `**/*.jar`

## 5) Generated Files Policy

Do **not** hand-edit generated files unless explicitly requested.

Flutter generated (committed):
- `packages/app/lib/**/*.g.dart`
- `packages/app/lib/**/*.freezed.dart`
- `packages/app/lib/**/*.gr.dart`

Regenerate when needed:
- `cd packages/app && dart run build_runner build --delete-conflicting-outputs`

Backend native-image generated/merged configs:
- `packages/backend/src/main/resources/jni-config.json`
- `packages/backend/src/main/resources/proxy-config.json`
- `packages/backend/src/main/resources/resource-config.json`
- `packages/backend/processor/src/main/resources/reflect-config-sample.json`

## 6) Package Routing + First Files to Read

### Backend (`packages/backend`)
Use for API/auth/db/websocket/mail/Liquibase/native-image concerns.

Execution prerequisite:
- Backend tasks require Java 21. If local `JAVA_HOME` is 17, override per command (do not change global config) before running backend Moon/Gradle tasks.
- PowerShell helper pattern:
  - `$jdk21 = Get-ChildItem "$env:USERPROFILE\\.jdks" -Directory | Where-Object { $_.Name -match '21' } | Sort-Object Name -Descending | Select-Object -First 1`
  - `$env:JAVA_HOME = $jdk21.FullName; $env:PATH = "$env:JAVA_HOME\\bin;$env:PATH"`
  - then run `bunx @moonrepo/cli run backend:<task>` or `./gradlew ...`

Read first:
- `packages/backend/build.gradle.kts`
- `packages/backend/gradle.properties`
- `packages/backend/src/main/resources/liquibase-changelog.sql`

Preferred task entrypoints:
- `bunx @moonrepo/cli run backend:lint`
- `bunx @moonrepo/cli run backend:test`
- `bunx @moonrepo/cli run backend:build`
- `bunx @moonrepo/cli run backend:package`

Direct Gradle (only if needed):
- `cd packages/backend && ./gradlew test --tests "hollybike.api.EventTest" --no-daemon`
- `cd packages/backend && ./gradlew test --tests "hollybike.api.EventTest" --tests "*Should create an event*" --no-daemon`

DB convention reminder:
- Liquibase changelog is SQL-only and uses `--changeset author:id [context:...]`.

### Frontend (`packages/frontend`)
Use for back-office web UI.

Read first:
- `packages/frontend/package.json`
- `packages/frontend/eslint.config.js`
- `packages/frontend/src/config/backendBaseUrl.ts`
- `docs/design-system.md` (if UI/style changes)

Preferred task entrypoints:
- `bunx @moonrepo/cli run frontend:lint`
- `bunx @moonrepo/cli run frontend:build`

Direct package commands (fallback):
- `cd packages/frontend && bun run lint`
- `cd packages/frontend && bun run build`

Common env:
- `VITE_BACKEND_BASE_URL`
- `VITE_MAPBOX_KEY`

### Mobile App (`packages/app`)
Use for Flutter Android app.

Read first:
- `packages/app/pubspec.yaml`
- `packages/app/analysis_options.yaml`
- `packages/app/lib/app/app_router.dart`

Preferred task entrypoints:
- `bunx @moonrepo/cli run app:lint`
- `bunx @moonrepo/cli run app:test`

Direct package commands (fallback):
- `cd packages/app && flutter analyze`
- `cd packages/app && flutter test`
- `cd packages/app && flutter pub get`

Packaging tasks require env values (ex: `VERSION`, `MAPBOX_PUBLIC_ACCESS_TOKEN`).

### Infrastructure (`packages/infrastructure`)
Use for Terraform work.

Read first:
- `packages/infrastructure/moon.yml`
- `packages/infrastructure/k8s/*.tf` (only files relevant to change)

Preferred task entrypoints:
- `bunx @moonrepo/cli run infrastructure:lint`
- `bunx @moonrepo/cli run infrastructure:validate`
- `bunx @moonrepo/cli run infrastructure:plan`

Direct Terraform commands (fallback):
- `cd packages/infrastructure/k8s && terraform fmt -check -recursive`
- `cd packages/infrastructure/k8s && terraform init -input=false -no-color`
- `cd packages/infrastructure/k8s && terraform validate -no-color`

Never run `terraform apply` unless explicitly requested.

## 7) Installed External Skill (ClawHub)

### `monorepo`

Installed skill location:
- `C:\Users\loic\.openclaw\workspace\skills\monorepo\SKILL.md`

Use this skill as a strategy reference for:
- dependency/workspace hygiene,
- task graph/caching improvements,
- CI optimization,
- package/versioning workflows.

Important: this repo’s orchestrator is **Moonrepo**, not Turborepo/Nx.
Apply `monorepo` principles, but keep implementation aligned with existing Moon + package-local tooling.

## 8) Minimal Validation Matrix

Run only what matches touched area:

- Frontend TS/TSX/CSS:
  - `bunx @moonrepo/cli run frontend:lint`
  - `bunx @moonrepo/cli run frontend:build` (if behavior/types/build output impacted)

- Backend Kotlin/API/DB:
  - Prefer targeted Gradle tests (class/test filter), avoid full suite unless requested.
  - `bunx @moonrepo/cli run backend:test` only when scope justifies.

- Flutter Dart:
  - `bunx @moonrepo/cli run app:test`
  - `bunx @moonrepo/cli run app:lint`

- Terraform:
  - `bunx @moonrepo/cli run infrastructure:lint`
  - `bunx @moonrepo/cli run infrastructure:validate`
  - `bunx @moonrepo/cli run infrastructure:plan` (if planning impact is relevant)

If a required tool is missing locally, state that explicitly.

## 9) CI Parity Notes

Keep local validation consistent with workflows in `.github/workflows/`, including:

- `build-frontend.yml`
- `build-backend.yml`
- `build-backend-on-premises.yml`
- `app.yml` / `app-build.yml` / `app-deploy.yml`
- `infrastructure.yml`
- `release.yml`
- `backend-frontend*.yml`

Execution mode reminder:
- For PR-equivalent local checks, prefer `bunx @moonrepo/cli ci <project>:<task>` when feasible.
- Use `bunx @moonrepo/cli run <project>:<task>` for non-PR/local ad-hoc execution.

When uncertain, inspect the exact workflow job before changing commands or assumptions.

## 10) Git Execution Policy

Commit behavior:
- Agents should commit as often as practical.
- Default granularity is **one commit per logical change**.
- Use short conventional commit messages compatible with commitlint (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, etc.).
- Keep commit subjects concise and task-scoped.

Identity requirements:
- Use the configured repo/global git identity (`git config user.name` and `git config user.email`).
- Do **not** set temporary "Codex" author/committer identity.
- If identity is missing, stop and report a blocker instead of committing with a fallback identity.

Safety gates before commit:
- Commit only files directly related to the current task.
- Run minimal touched-area validation before each commit when possible.
- If checks cannot run, commits are allowed only if the final report explicitly states what did not run and why.

Push/history restrictions:
- Never run `git push` (including `--force`, tags, or creating remote branches).
- Never rewrite history (`commit --amend`, rebase, reset, or force-update refs) unless explicitly requested.

Pull request workflow (explicit user request only):
- If the user explicitly says "create a PR", use GitHub CLI (`gh`) to create the PR.
- This explicit request is the only allowed exception to the no-push default: push the current branch only as needed to open the PR.
- If the user does not specify a base branch, always create the PR against `main` (for example with `gh pr create --base main`).
- Create a strong PR title: concise, imperative, and scoped to the main change.
- Create a complete PR description with: summary, files changed, validation performed, and known risks/blockers.
- Add relevant labels by listing available labels first (`gh label list`) and applying best matches for impacted area and change type (for example: `backend`, `frontend`, `app`, `infrastructure`, `docs`, `bug`, `enhancement`, `refactor`, `ci`).
- If `gh pr edit --add-label` fails due GitHub GraphQL/project metadata issues, fallback to REST: `gh api repos/<owner>/<repo>/issues/<pr_number>/labels -X POST -f labels[]=<label>`.
- If a desired label does not exist in the repository, skip it and continue without failing PR creation.

## 11) Response Format for Agent Outputs

Keep responses concise and deterministic:

1. What changed.
2. Files changed.
3. Commands run + pass/fail.
4. Blockers or assumptions.

Avoid long narrative. Avoid dumping large file contents unless requested.
