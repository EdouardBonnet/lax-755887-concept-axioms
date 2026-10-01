import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import fs from 'node:fs';
import assert from 'node:assert/strict';
const root = fileURLToPath(new URL('../', import.meta.url));
const playwright = process.env.PLAYWRIGHT_MODULE || path.resolve(root, '../lax-website/node_modules/playwright-core/index.mjs');
const { chromium } = await import(pathToFileURL(playwright).href);
const output = JSON.parse(fs.readFileSync(`${root}/build-output.json`, 'utf8'));
const base = process.env.PREVIEW_URL || 'http://localhost:8123/lax-755887/';
const browser = await chromium.launch({executablePath: process.env.CHROME || '/usr/bin/google-chrome', headless: true, args: ['--no-sandbox']});
const page = await browser.newPage({viewport: {width: 1440, height: 1100}});
const errors = [];
page.on('pageerror', err => errors.push(err.message));
await page.goto(base, {waitUntil:'networkidle'});
await page.screenshot({path: `${root}/audit/results/preview.png`, fullPage: true});
assert.match(await page.locator('body').innerText(), /Concept axioms/);
const proofChecks=[];
for (const proof of output.proofs) {
  await page.goto(`${base}${proof.id}.html`, {waitUntil:'domcontentloaded'});
  const pill = (await page.locator('.proof-microline .status-pill').innerText()).trim();
  assert.equal(pill, proof.assumptions.length ? 'conditional — 1 open assumption' : 'grounded', proof.id);
  proofChecks.push({id:proof.id,status:pill});
}
const conceptChecks=[];
for (const concept of output.concepts.filter(c => c.statements.length)) {
  await page.goto(`${base}${concept.id}.html`, {waitUntil:'domcontentloaded'});
  const lines = await page.locator('.statement-line').evaluateAll(nodes => nodes.map(n=>({classes:n.className,text:n.textContent})));
  assert(lines.length >= concept.statements.length, concept.id);
  const expected = concept.id.endsWith('Controls') || concept.id.endsWith('MergeControl') ? 'line-proven' : 'line-open';
  assert(lines.every(l=>l.classes.split(' ').includes(expected)), concept.id + JSON.stringify(lines));
  conceptChecks.push({id:concept.id,status:expected,statements:concept.statements.length});
}
assert.deepEqual(errors, []);
fs.writeFileSync(`${root}/audit/results/browser.json`, JSON.stringify({proofChecks,conceptChecks,errors}, null, 2)+'\n');
await browser.close();
console.log(`PASS: ${proofChecks.length} proof-page statuses, 26 statement source statuses, no browser errors.`);
