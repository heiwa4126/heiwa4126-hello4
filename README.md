# @heiwa4126/hello4

TypeScript hello world library with dual ES modules/CommonJS support.

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
- `npm test` - Run tests in watch mode
- `npm run test:run` - Run tests once
- `npm run clean` - Remove build artifacts

## License

MIT
