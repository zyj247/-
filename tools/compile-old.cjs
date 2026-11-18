const fs=require('fs'),path=require('path'); const solc=require('solc-0425');
const root=path.resolve(__dirname,'../答案'); let fail=false;
function run(n, entry){ const dir=path.join(root,`第${n}套代码-完整/模块二/智能合约开发`); const source=fs.readFileSync(path.join(dir,entry),'utf8'); const out=solc.compile({sources:{[entry]:source}},1,(file)=>({contents:fs.readFileSync(path.join(dir,file),'utf8')})); console.log(`=== set${n}/${entry} ===`); for(const e of out.errors||[]) console.log(e); const errors=(out.errors||[]).filter(e=>String(e).includes('Error')); if(errors.length) fail=true; console.log('contracts=',Object.keys(out.contracts||{})); }
run(5,'ElectronicSeal.sol'); run(6,'Trace.sol'); process.exitCode=fail?1:0;
