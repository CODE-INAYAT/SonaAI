import fs from 'node:fs';
import path from 'node:path';

const projectRoot = process.cwd();
const envPath = path.join(projectRoot, '.env');
const envExamplePath = path.join(projectRoot, 'env.local.example');

function fail(message) {
  console.error(message);
  process.exit(1);
}

const majorVersion = Number.parseInt(process.versions.node.split('.')[0], 10);
if (Number.isNaN(majorVersion) || majorVersion < 22) {
  fail(`Node.js 22 or newer is required. Current version: ${process.versions.node}`);
}

// npm is the standard package manager for this project

if (!fs.existsSync(envExamplePath)) {
  fail('Missing env.local.example. Restore the tracked template before continuing.');
}

if (!fs.existsSync(envPath)) {
  fail('Missing .env. Copy env.local.example to .env before running the app.');
}

const envContents = fs.readFileSync(envPath, 'utf8');
for (const key of ['NEXT_PUBLIC_AGORA_APP_ID', 'NEXT_AGORA_APP_CERTIFICATE']) {
  const matcher = new RegExp(`^${key}=.+$`, 'm');
  if (!matcher.test(envContents)) {
    fail(`.env is missing a value for ${key}`);
  }
}

console.log('Doctor checks passed');
