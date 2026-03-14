# HollyBike Monorepo

HollyBike is a multi-package repository orchestrated with [Moonrepo](https://moonrepo.dev/).

## Packages

- `packages/frontend`: Preact + TypeScript + Vite (Bun)
- `packages/backend`: Kotlin + Ktor + Gradle + GraalVM native build
- `packages/app`: Flutter Android app
- `packages/infrastructure`: Terraform (`k8s`, `aws`, `init_backend`)

## Monorepo Tooling

- Task orchestrator: `moon` (`@moonrepo/cli` pinned to `2.0.4`)
- JavaScript runtime: Bun `1.3.10`
- Node runtime: Node `20.19.0`
- Git hooks: Husky + lint-staged + commitlint

Moon configuration lives in `.moon/` and each package defines tasks in `packages/*/moon.yml`.

## Prerequisites

Install these tools locally:

- Bun `>= 1.3.x`
- Node `>= 20`
- Java 21 (backend)
- Flutter stable (app)
- Terraform (infrastructure)
- Docker + Buildx (image/package tasks)

## Getting Started

Install root dependencies:

```bash
bun install
```

List all Moon projects:

```bash
bunx @moonrepo/cli projects
```

List all Moon tasks:

```bash
bunx @moonrepo/cli tasks
```

## Common Commands

### Frontend

```bash
bunx @moonrepo/cli run frontend:lint
bunx @moonrepo/cli run frontend:build
```

### Backend

```bash
bunx @moonrepo/cli run backend:test
bunx @moonrepo/cli run backend:package
```

### Mobile App

```bash
bunx @moonrepo/cli run app:test
bunx @moonrepo/cli run app:lint
```

### Infrastructure

```bash
bunx @moonrepo/cli run infrastructure:lint
bunx @moonrepo/cli run infrastructure:validate
bunx @moonrepo/cli run infrastructure:plan
```

## Packaging and Deploy Tasks

These tasks require environment variables/secrets (usually from CI):

### Frontend image publish

```bash
REGISTRY=ghcr.io IMAGE_NAME=<owner/repo-frontend> VERSION=v1.2.3 \
  bunx @moonrepo/cli run frontend:package
```

### Backend native + image publish

```bash
IMAGE_NAME=hollybike_server bunx @moonrepo/cli run backend:package

REGISTRY=ghcr.io IMAGE_NAME=<owner/repo-backend> VERSION=v1.2.3 EXECUTABLE=hollybike_server \
  bunx @moonrepo/cli run backend:publish
```

### App artifacts

```bash
VERSION=v1.2.3 MAPBOX_PUBLIC_ACCESS_TOKEN=<token> \
  bunx @moonrepo/cli run app:package-aab

VERSION=v1.2.3 MAPBOX_PUBLIC_ACCESS_TOKEN=<token> \
  bunx @moonrepo/cli run app:package-apk
```

### Infrastructure apply

```bash
bunx @moonrepo/cli run infrastructure:deploy
```

## Git Hooks

- Pre-commit runs `lint-staged`.
- Commit messages are validated by commitlint (`@commitlint/config-conventional`).

Manual run:

```bash
bun run lint-staged
```

## CI/CD

GitHub Actions workflows remain split by domain and call Moon tasks internally:

- `.github/workflows/build-frontend.yml`
- `.github/workflows/build-backend.yml`
- `.github/workflows/build-backend-on-premises.yml`
- `.github/workflows/app.yml`
- `.github/workflows/infrastructure.yml`
- `.github/workflows/release.yml`

PR workflows use Moon affected/CI mode where configured (`moon ci ...`), while release/deploy paths use explicit `moon run ...` task targets.

## Dependabot

Dependabot is configured in `.github/dependabot.yml` for:

- Gradle (`/packages/backend`)
- Bun (`/` and `/packages/frontend`)
- Pub (`/packages/app`)
- Terraform (`/packages/infrastructure/k8s`, `/aws`, `/init_backend`)

## Notes

- Liquibase changelog file is `packages/backend/src/main/resources/liquibase-changelog.sql`.
- Flutter generated files are committed in this repo (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`).
- Terraform apply is expected to run in CI unless explicitly needed locally.
