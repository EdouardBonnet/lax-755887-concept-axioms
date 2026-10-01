import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import fs from 'node:fs';
import assert from 'node:assert/strict';
const root = fileURLToPath(new URL('../', import.meta.url));
const playwright = process.env.PLAYWRIGHT_MODULE || path.resolve(root, '../lax-website/node_modules/playwright-core/index.mjs');
const { chromium } = await import(pathToFileURL(playwright).href);
const output = JSON.parse(fs.readFileSync(`${root}/build-output.json`, 'utf8'));
const expected = JSON.parse(fs.readFileSync(`${root}/audit/expected-status.json`, 'utf8'));
const statementStatus = new Map([...expected.proven.map(id => [id, 'proven']), ...expected.open.map(id => [id, 'open'])]);
assert.equal(statementStatus.size, 26);
assert.deepEqual(output.concepts.flatMap(c => c.statements.map(s => s.id)).sort(), [...statementStatus.keys()].sort());
const conceptStatus = new Map(output.concepts.map(c => [c.id, c.statements.length ?
  c.statements.every(s => statementStatus.get(s.id) === 'proven') ? 'proven' : 'open' : 'none']));
assert.deepEqual([...conceptStatus].filter(([, s]) => s === 'none').map(([id]) => id).sort(), [...expected.definitions].sort());
const colors = {proven:'rgb(232, 245, 232)', open:'rgb(252, 243, 217)'};
const base = process.env.PREVIEW_URL || 'http://localhost:8123/lax-755887/';
const browser = await chromium.launch({executablePath: process.env.CHROME || '/usr/bin/google-chrome', headless: true, args: ['--no-sandbox']});
const proofChecks=[], conceptChecks=[], badgeChecks=[], graphChecks=[];
const errors=[];
try {
  const page = await browser.newPage({viewport: {width:1440, height:1100}});
  page.on('pageerror', err => errors.push(err.message));
  await page.goto(base, {waitUntil:'networkidle'});
  await page.locator('svg[aria-label="Proof dependency graph"] .net-node').first().waitFor();
  await page.screenshot({path:`${root}/audit/results/preview.png`,fullPage:true});
  for (const [id, status] of conceptStatus) {
    const badge = await page.locator(`li:has(> a[title="${id}"]) > .type-badge`).evaluate(e => ({classes:[...e.classList],color:getComputedStyle(e).backgroundColor}));
    assert.equal(badge.classes.includes('proven'), status === 'proven', id);
    assert.equal(badge.classes.includes('open'), status === 'open', id);
    if (status !== 'none') assert.equal(badge.color, colors[status], id);
    badgeChecks.push({id,status,...badge});
  }
  const graph = await page.locator('.prepared-graph .net-node, .prepared-graph .net-dock').evaluateAll(nodes => nodes.map(e=>({
    graph:e.closest('svg').getAttribute('aria-label'), classes:[...e.classList], href:e.getAttribute('href'),
    fill:getComputedStyle(e.querySelector('rect,circle')).fill,
  })));
  const representedStatements = new Set(), representedConcepts = new Set();
  for (const node of graph) {
    const url = new URL(node.href, base);
    const id = node.classes.includes('net-dock') ? decodeURIComponent(url.hash).slice(3) : decodeURIComponent(url.pathname.split('/').pop()).replace(/\.html$/, '');
    const status = node.classes.includes('net-dock') ? statementStatus.get(id) : conceptStatus.get(id);
    assert(status, id);
    assert(node.classes.includes(status), id);
    if (status !== 'none') assert.equal(node.fill, colors[status], id);
    if (node.graph === 'Concept dependency graph') representedConcepts.add(id);
    if (node.graph === 'Proof dependency graph') {
      if (statementStatus.has(id)) representedStatements.add(id);
      else {
        const c = output.concepts.find(c=>c.id === id);
        if (c.statements.length === 1) representedStatements.add(c.statements[0].id);
      }
    }
    graphChecks.push({id,status,...node});
  }
  assert.deepEqual([...representedConcepts].sort(), [...conceptStatus.keys()].sort());
  assert.deepEqual([...representedStatements].sort(), [...statementStatus.keys()].sort());
  for (const proof of output.proofs) {
    await page.goto(`${base}${proof.id}.html`, {waitUntil:'domcontentloaded'});
    const pill = (await page.locator('.proof-microline .status-pill').innerText()).trim();
    const grounded = proof.assumptions.every(id=>statementStatus.get(id) === 'proven');
    assert.equal(pill, grounded ? 'grounded' : 'conditional — 1 open assumption', proof.id);
    proofChecks.push({id:proof.id,status:pill});
  }
  for (const concept of output.concepts.filter(c=>c.statements.length)) {
    await page.goto(`${base}${concept.id}.html`, {waitUntil:'domcontentloaded'});
    for (const statement of concept.statements) assert.equal(await page.locator(`[id="s-${statement.id}"]`).count(), 1, statement.id);
    const lines = await page.locator('.statement-line').evaluateAll(nodes=>nodes.map(n=>({classes:n.className,color:getComputedStyle(n.querySelector('td')).backgroundColor})));
    const status = conceptStatus.get(concept.id);
    assert(lines.length >= concept.statements.length, concept.id);
    assert(lines.every(l=>l.classes.split(' ').includes(`line-${status}`)), concept.id);
    assert(lines.every(l=>l.color === colors[status]), concept.id + JSON.stringify(lines));
    conceptChecks.push({id:concept.id,status,statements:concept.statements.length});
  }
  assert.deepEqual(errors, []);
  fs.writeFileSync(`${root}/audit/results/browser.json`, JSON.stringify({badgeChecks,graphChecks,proofChecks,conceptChecks,errors},null,2)+'\n');
  console.log(`PASS: all 24 concept badges, ${graphChecks.length} graph nodes/docks, 26 statement source colors, and 21 proof-page statuses match the explicit expectations.`);
} finally {
  await browser.close();
}
