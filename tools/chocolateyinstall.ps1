$ErrorActionPreference = 'Stop';

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/pritunl/pritunl-client-electron/releases/download/1.3.3289.33/Pritunl.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  softwareName  = 'pritunl client*'
  checksum      = '543cc836ca0babb2335a3f2a6e9dd12feeedd2e0fdca3b6114a275037555c58e'
  checksumType  = 'sha256'
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0,1)
}

Install-ChocolateyPackage @packageArgs