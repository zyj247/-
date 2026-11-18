$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$required = @('FlightDelayInsurance.sol','FlightManagement.sol','Claims.sol','README.md','答案对照.md')
foreach ($name in $required) {
  if (-not (Test-Path (Join-Path $root $name))) { throw "missing $name" }
}
foreach ($name in @('FlightDelayInsurance.sol','FlightManagement.sol','Claims.sol')) {
  $text = Get-Content -Raw -LiteralPath (Join-Path $root $name)
  if ($text -match '\bTODO\b|\*\*\*') { throw "answer contains blank marker: $name" }
  if ($text -notmatch 'pragma solidity 0\.8\.3;') { throw "compiler pragma missing: $name" }
}
$blank = Join-Path (Resolve-Path (Join-Path $root '..\..\..\..\..\赛题\第7套代码-挖空\模块二\智能合约开发')).Path
foreach ($name in @('FlightDelayInsurance.sol','FlightManagement.sol','Claims.sol')) {
  $text = Get-Content -Raw -LiteralPath (Join-Path $blank $name)
  if ($text -notmatch '\bTODO\b' -or $text -notmatch '\*\*\*') { throw "blank markers missing: $name" }
}
$solc = Get-Command solc -ErrorAction SilentlyContinue
if ($null -eq $solc) { Write-Output 'PASS: static checks complete; solc not installed, no compiler run.'; exit 0 }
& $solc.Source --version
& $solc.Source --base-path $root --include-path $root --bin --abi (Join-Path $root 'FlightDelayInsurance.sol') (Join-Path $root 'FlightManagement.sol') (Join-Path $root 'Claims.sol')
Write-Output 'PASS: static checks and solc compilation complete.'
