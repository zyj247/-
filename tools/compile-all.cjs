const fs = require('fs');
const path = require('path');
const compilers = {
  '第4套代码-完整': require('solc-0610'),
  '第5套代码-完整': require('solc-0425'),
  '第6套代码-完整': require('solc-0425'),
  '第7套代码-完整': require('solc-083'),
  '第8套代码-完整': require('solc-083'),
  '第9套代码-完整': require('solc-083'),
  '第10套代码-完整': require('solc-083')
};
const root = path.resolve(__dirname, '..', '答案');
let failed = false;
function compile(solc, sources) {
  const input = { language: 'Solidity', sources, settings: { outputSelection: { '*': { '*': ['abi', 'evm.bytecode.object'] } } } };
  if (solc.compileStandardWrapper) return solc.compileStandardWrapper(input);
  const raw = solc.compile(JSON.stringify(input));
  return typeof raw === 'string' ? JSON.parse(raw) : raw;
}
for (const [setDir, solc] of Object.entries(compilers)) {
  const dir = path.join(root, setDir, '模块二', '智能合约开发');
  if (!fs.existsSync(dir)) { console.log(`SKIP ${setDir}: missing`); continue; }
  const files = fs.readdirSync(dir).filter(f => f.endsWith('.sol'));
  const sources = {};
  let hasPlaceholder = false;
  for (const file of files) {
    const source = fs.readFileSync(path.join(dir, file), 'utf8');
    if (source.trim() === 'x') { console.log(`ERROR ${setDir}/${file}: placeholder`); failed = true; hasPlaceholder = true; }
    sources[file] = { content: source };
  }
  if (hasPlaceholder) continue;
  let output;
  try { output = compile(solc, sources); } catch (e) { console.log(`ERROR ${setDir}: ${e.message}`); failed = true; continue; }
  const errors = (output.errors || []).filter(e => e.severity === 'error');
  console.log(`\n=== ${setDir} (${files.length} files) ===`);
  for (const e of output.errors || []) console.log(`${e.severity}: ${e.formattedMessage}`);
  if (errors.length) failed = true;
}
process.exitCode = failed ? 1 : 0;
