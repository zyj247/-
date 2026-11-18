const fs = require('fs');
const path = require('path');
const solc = require('solc-0610');

const root = path.resolve(__dirname, '..');
const dir = path.join(root, '答案', '第4套代码-完整', '模块二', '智能合约开发');
const files = ['Material.sol', 'Logistics.sol'];
let failed = false;
for (const file of files) {
  const filePath = path.join(dir, file);
  const source = fs.readFileSync(filePath, 'utf8');
  const input = { language: 'Solidity', sources: { [file]: { content: source } }, settings: { outputSelection: { '*': { '*': ['abi', 'evm.bytecode.object'] } } } };
  const output = JSON.parse(solc.compile(JSON.stringify(input)));
  const errors = (output.errors || []).filter(e => e.severity === 'error');
  console.log(`\n=== ${file} ===`);
  for (const e of output.errors || []) console.log(`${e.severity}: ${e.formattedMessage}`);
  if (errors.length) failed = true;
}
process.exitCode = failed ? 1 : 0;
