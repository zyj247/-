const fs = require('fs');
const path = require('path');
const assert = require('assert/strict');
const solc = require('solc-0610');
const { ethers } = require('ethers');
const ganache = require('ganache');

(async () => {
  const engine = ganache.provider({logging:{quiet:true},wallet:{totalAccounts:6},chain:{hardfork:'istanbul'}});
  const provider = new ethers.BrowserProvider(engine);
  provider.pollingInterval = 10;
  const sender = await provider.getSigner(0);
  const [cargo, origin, destination, other] = await Promise.all([1,2,3,4].map(async i => (await provider.getSigner(i)).getAddress()));
  const dir = path.resolve(__dirname,'../答案/第4套代码-完整/模块二/智能合约开发');
  async function deploy(file,name) {
    const input={language:'Solidity',sources:{[file]:{content:fs.readFileSync(path.join(dir,file),'utf8')}},settings:{outputSelection:{'*':{'*':['abi','evm.bytecode.object']}}}};
    const out=JSON.parse(solc.compile(JSON.stringify(input)));
    const errors=(out.errors||[]).filter(e=>e.severity==='error');
    assert.equal(errors.length,0,errors.map(e=>e.formattedMessage).join('\n'));
    const c=out.contracts[file][name];
    const instance=await new ethers.ContractFactory(c.abi,c.evm.bytecode.object,sender).deploy();
    await instance.waitForDeployment();
    return instance;
  }
  const material=await deploy('Material.sol','Material');
  assert.equal(await material.newMaterial.staticCall('potato','1001','none'),await material.getAddress());
  await (await material.newMaterial('potato','1001','none')).wait();
  const m=await material.getMaterial('1001');
  assert.equal(m[0],await sender.getAddress());
  assert.equal(m[1],'potato');assert.equal(m[2],'1001');assert.equal(m[3],'none');assert(m[4]>0n);assert.equal(m[5],true);
  await assert.rejects(material.newMaterial.staticCall('other','1001','overwrite'));
  assert.equal((await material.getMaterial('missing'))[5],false);
  console.log('PASS Material: deploy, returned address, 6-field read, duplicate rejection, missing id');
  const logistics=await deploy('Logistics.sol','Logistics');
  await (await logistics.addLogistics(cargo,origin,destination,'first')).wait();
  await (await logistics.addLogistics(cargo,destination,origin,'second')).wait();
  await (await logistics.addLogistics(other,origin,destination,'other')).wait();
  assert.equal(await logistics.recordCount(),3n);
  let rows=await logistics.getLogisticsInfo.staticCall(cargo);
  assert.equal(rows.length,2);assert.equal(rows[0].memo,'first');assert.equal(rows[1].memo,'second');assert.equal(rows[0].queryCount,1n);
  assert.equal(await logistics.queryCount(),0n,'eth_call must not persist counters');
  await (await logistics.getLogisticsInfo(cargo)).wait();
  assert.equal(await logistics.queryCount(),1n);
  rows=await logistics.getLogisticsInfo.staticCall(cargo);
  assert.equal(rows[0].queryCount,2n);assert.equal(rows[1].queryCount,2n);
  assert.equal((await logistics.getLogisticsInfo.staticCall(ethers.ZeroAddress)).length,0);
  console.log('PASS Logistics: deploy, ordered filtering, totals, persisted transaction counters, eth_call distinction, empty result');
  await engine.disconnect();
})().catch(e=>{console.error(e);process.exitCode=1;});
