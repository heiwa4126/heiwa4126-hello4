# AI Coding Agent Instructions for @heiwa4126/hello4

## Project Overview

This is an npm package written in TypeScript, created as **an implementation example of GitHub Actions Trusted Publishing with Sigstore attestation**. Functionally, it's a simple hello world library, but the essence of this project lies in implementing a **modern npm package publishing pipeline**.

## Architecture & Build System

### Dual Module System (ESM + CJS)

This project supports both ESM and CommonJS:

- **ESM build**: `tsconfig.esm.json` → `dist/esm/*.js` (including type definitions)
- **CJS build**: `tsconfig.cjs.json` → `dist/cjs/*.cjs`
- **Important**: CJS files are renamed from `.js` → `.cjs` (via `rename-cjs` script)

Both module systems are supported through the `package.json` exports field:

```json
"exports": {
  ".": {
    "types": "./dist/esm/hello.d.ts",
    "import": "./dist/esm/hello.js",
    "require": "./dist/cjs/hello.cjs"
  }
}
```

### Build Flow

```bash
npm run build  # Executes ESM → CJS → rename-cjs in order
```

**Why this order?** The CJS build generates `.js` files, which must then be renamed to `.cjs`.

## Critical Developer Workflows

### Testing and Pre-publish Checks

```bash
npm run lint          # Code check with Biome
npm test              # Run tests with Vitest
npm run smoke-test    # Test actual dist files in 3 formats (mjs/cjs/ts)
npm run prepublishOnly # lint + test + clean + build + smoke-test
```

**Important**: `prepublishOnly` runs automatically on `npm publish`. You can use it for manual local testing.

### Publishing Workflow

**Direct local publishing is discouraged**. Use GitHub Actions Trusted Publishing:

1. Update version: `npm version [patch|minor|major|prerelease]`
2. Push tags: `git push --follow-tags`
3. GitHub Actions automatically publishes to npmjs

**Tag formats**:

- Regular release: `v1.2.3`
- Prerelease: `v1.2.3-rc.1` (contains hyphen) → `dev` tag on npm

### Trusted Publishing Mechanism

`.github/workflows/publish.yml` implements:

- **OIDC authentication**: `id-token: write` permission + `npm publish` (no token required)
- **Owner restriction**: `if: github.repository_owner == github.actor`
- **Prerelease detection**: If version string contains `-`, use `--tag dev`
- **Sigstore attestation**: Automatically attached when using Trusted Publishing

## Project Conventions

### File Extensions in Import Statements

**Explicitly use `.js` extension** even in TypeScript source code:

```typescript
import { hello } from "./hello.js"; // ✓ Correct
import { hello } from "./hello"; // ✗ Avoid
```

Reason: Resolves correctly at runtime as ESM

### Test File Placement

- Test files: `test/*.test.ts`
- Excluded from build: `**/*.test.ts` in `tsconfig.*.json` `exclude`

### Example Files (examples/)

`examples/` contains test files in 3 formats:

- `test1.mjs`: Direct execution as ESM
- `test2.cjs`: Execution as CommonJS
- `test3.ts`: Execution as TypeScript with tsx

These are executed by the `smoke-test` script to verify build artifacts

## Tooling

- **Testing**: Vitest (native TypeScript support)
- **Linter/Formatter**: Biome (configured in `.biome.jsonc`)
- **TypeScript**: Strict mode with 3 tsconfig files (base, esm, cjs)

## Security & Access Control

### npm Publishing Restrictions

Recommended project settings:

- Enable "Require two-factor authentication and disallow tokens"
- This allows publishing only via Trusted Publishing

### Environment Variables and Secrets

- GitHub Actions uses `environment: npmjs`
- Local `~/.npmrc` should be deleted after Trusted Publishing setup

## Key Files Reference

- `NOTE-ja.md`: Detailed Japanese documentation (design decision rationale, etc.)
- `.github/workflows/publish.yml`: Trusted Publishing implementation
- `package.json`: `prepublishOnly` script contains full check flow
- `tsconfig.*.json`: 3 configurations supporting dual module system

## When Modifying This Project

- Maintain `src/hello.ts` and `test/hello.test.ts` pair when adding features
- Must verify 3 formats with `smoke-test` script when changing build
- Recommend local testing with `nektos/act` etc. when changing GitHub Actions
