const fs = require('fs');
const path = require('path');
const { ethers } = require('ethers');
const ganache = require('ganache');
const compilers = { v0425: require('solc-0425'), v0610: require('solc-0610'), v083: require('solc-083') };
const root = path.resolve(__dirname, '..', '答案');

function compile(version, dir, entry) {
  const solc = compilers[version];
  if (version === 'v0425') {
    const source = fs.readFileSync(path.join(dir, entry), 'utf8');
    const output = solc.compile({sources:{[entry]:source}}, 1, file => ({contents:fs.readFileSync(path.join(dir,file), 'utf8')}));
    const errors = (output.errors || []).filter(x => /Error/.test(String(x)));
    if (errors.length) throw new Error(errors.join('\n'));
    const contracts = {};
    for (const [key, item] of Object.entries(output.contracts || {})) {
      const split = key.lastIndexOf(':');
      const file = key.slice(0, split);
      const name = key.slice(split + 1);
      contracts[file] = contracts[file] || {};
      contracts[file][name] = {abi: JSON.parse(item.interface), evm:{bytecode:{object:item.bytecode}}};
    }
    return contracts;
  }
  const sources = {};
  for (const file of fs.readdirSync(dir).filter(x => x.endsWith('.sol'))) {
    sources[file] = { content: fs.readFileSync(path.join(dir, file), 'utf8') };
  }
  const input = { language:'Solidity', sources, settings:{outputSelection:{'*':{'*':['abi','evm.bytecode.object']}}} };
  const output = solc.compileStandardWrapper ? solc.compileStandardWrapper(input) : JSON.parse(solc.compile(JSON.stringify(input)));
  const errors = (output.errors || []).filter(x => x.severity === 'error');
  if (errors.length) throw new Error(errors.map(x => x.formattedMessage).join('\n'));
  return output.contracts;
}

(async () => {
  const engine = ganache.provider({logging:{quiet:true}, wallet:{totalAccounts:10}, chain:{hardfork:'istanbul'}});
  const provider = new ethers.BrowserProvider(engine);
  const signers = await Promise.all([...Array(8)].map((_,i)=>provider.getSigner(i)));
  const addresses = await Promise.all(signers.map(x=>x.getAddress()));
  const deployed = [];
  async function deploy(group, version, dir, file, contract, signerIndex, args=[]) {
    const out = compile(version, dir, file);
    const item = out[file][contract];
    if (!item || !item.evm.bytecode.object) throw new Error(`${group}: missing bytecode ${file}:${contract}`);
    const factory = new ethers.ContractFactory(item.abi, item.evm.bytecode.object, signers[signerIndex || 0]);
    const instance = await factory.deploy(...args);
    await instance.waitForDeployment();
    deployed.push(`${group}/${contract}`);
    return instance;
  }
  const d = (n) => path.join(root, `第${n}套代码-完整`, '模块二', '智能合约开发');
  try {
    const d4=d(4); await deploy('4/Material','v0610',d4,'Material.sol','Material',0); await deploy('4/Logistics','v0610',d4,'Logistics.sol','Logistics',0);
    const d5=d(5); const es=await deploy('5/ElectronicSeal','v0425',d5,'ElectronicSeal.sol','ElectronicSeal',0); await deploy('5/Seal','v0425',d5,'Seal.sol','Seal',0,['n','id','data','2023']); await deploy('5/MultiSeal','v0425',d5,'MultiSeal.sol','MultiSeal',0,[addresses[0],'code',2,[addresses[1],addresses[2]]]);
    const d6=d(6); await deploy('6/Trace','v0425',d6,'Trace.sol','Trace',0,[addresses[1],addresses[2],addresses[3]]); await deploy('6/FoodInfoItem','v0425',d6,'FoodInfoItem.sol','FoodInfoItem',0,['food','producer',0,addresses[1]]);
    const d7=d(7); await deploy('7/FlightDelayInsurance','v083',d7,'FlightDelayInsurance.sol','FlightDelayInsurance',0,[addresses[0],addresses[1],addresses[2],100,500]); await deploy('7/FlightManagement','v083',d7,'FlightManagement.sol','FlightManagement',0); await deploy('7/Claims','v083',d7,'Claims.sol','Claims',0,[addresses[0],addresses[1],addresses[2],100,500]);
    const d8=d(8); await deploy('8/MedicalDataSharingPlatform','v083',d8,'MedicalDataSharingPlatform.sol','MedicalDataSharingPlatform',0); await deploy('8/MedicalRecordManagement','v083',d8,'MedicalRecordManagement.sol','MedicalRecordManagement',0); await deploy('8/MedicalRecords','v083',d8,'MedicalRecords.sol','MedicalRecords',0);
    const d9=d(9); await deploy('9/RentalAgreement','v083',d9,'RentalAgreement.sol','RentalAgreement',0,[addresses[0],addresses[1],86400,ethers.keccak256(ethers.toUtf8Bytes('house'))]); await deploy('9/RentalContract','v083',d9,'RentalContract.sol','RentalContract',0,[addresses[0],addresses[1],3000,3000,1,9999999999,3600,3000]); await deploy('9/Rent','v083',d9,'Rent.sol','Rent',0);
    const d10=d(10); await deploy('10/PensionAccount','v083',d10,'PensionAccount.sol','PensionAccount',0); await deploy('10/PensionInsurance','v083',d10,'PensionInsurance.sol','PensionInsurance',0); await deploy('10/PensionTransfer','v083',d10,'PensionTransfer.sol','PensionTransfer',0);
    console.log(`PASS local deployment smoke: ${deployed.length} contracts`);
    for (const x of deployed) console.log(`  ${x}`);
  } finally { await engine.disconnect(); }
})().catch(err => { console.error('FAIL local deployment smoke'); console.error(err.stack || err); process.exitCode=1; });
