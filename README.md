# @heiwa4126/hello4

[![npm version](https://img.shields.io/npm/v/@heiwa4126/hello4.svg)](https://www.npmjs.com/package/@heiwa4126/hello4)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Node.js](https://img.shields.io/badge/Node.js-18%2B-green.svg)](https://nodejs.org/)

TypeScript hello world library with dual ES modules/CommonJS support. Features GitHub Actions trusted publishing to npmjs with Sigstore attestation.

## Installation

```bash
npm install @heiwa4126/hello4
```

## Usage

### As a library

#### ES Modules (MJS)

```typescript
import { hello } from "@heiwa4126/hello4";

console.log(hello()); // "Hello!"
```

#### CommonJS (CJS)

```javascript
const { hello } = require("@heiwa4126/hello4");

console.log(hello()); // "Hello!"
```

#### TypeScript

```typescript
import { hello } from "@heiwa4126/hello4";

console.log(hello()); // "Hello!"
```

### As a CLI tool

After installation, you can use the CLI command:

```bash
heiwa4126-hello4
```

## Development

```bash
# Install dependencies
npm install

# Build the project
npm run build

# Run tests
npm test

# Clean build artifacts
npm run clean
```

## Build Output

The project builds to both ES modules and CommonJS formats:

- `dist/esm/` - ES modules
- `dist/cjs/` - CommonJS

## Scripts

- `npm run build` - Build both ESM and CJS versions
- `npm run build:esm` - Build ES modules only
- `npm run build:cjs` - Build CommonJS only
- `npm run test:watch` - Run tests in watch mode
- `npm test` - Run tests once
- `npm run clean` - Remove build artifacts

## License

MIT

## Note

[NOTE-ja.md](https://github.com/heiwa4126/heiwa4126-hello4/blob/main/NOTE-ja.md) (at GitHub)
これがこのプロジェクトの本体。
