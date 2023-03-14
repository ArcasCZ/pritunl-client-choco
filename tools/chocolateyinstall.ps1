$ErrorActionPreference = 'Stop';

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/pritunl/pritunl-client-electron/releases/download/1.3.3467.51/Pritunl.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  softwareName  = 'pritunl client*'
  checksum      = 'cccba38e85a9f5718fc20a9ac94ecdbb180ee9ae5a488fbbbb63fddcc9a2ba00'
  checksumType  = 'sha256'
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0,1)
}

# If Pritunl is already installed and running, we have to
# kill the process. Otherwise the files won't be overwritten.

Get-Process pritunl -ErrorAction SilentlyContinue | Stop-Process

Install-ChocolateyPackage @packageArgs