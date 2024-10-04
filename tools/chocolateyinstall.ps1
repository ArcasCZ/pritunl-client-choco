$Timeout = 20

$ErrorActionPreference = 'Stop';

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/pritunl/pritunl-client-electron/releases/download/1.3.4026.10/Pritunl.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  softwareName  = 'pritunl client*'
  checksum      = 'c0a7c432fa5023100f6c59bb70cc098e356a0201472de341243cf9967456544f'
  checksumType  = 'sha256'
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0,1)
}

# If Pritunl is already installed and running, we have to
# kill the process. Otherwise the files won't be overwritten.

Get-Service pritunl -ErrorAction SilentlyContinue | Stop-Service -ErrorAction SilentlyContinue
Get-Process pritunl -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Install-ChocolateyPackage @packageArgs

Write-Host "Waiting for installer to complete the operations."

$timer = [Diagnostics.Stopwatch]::StartNew()

while (($timer.Elapsed.TotalSeconds -lt $Timeout) -and ($process -eq $None)) {
	$process = Get-Process -Name "Pritunl.tmp" -ErrorAction SilentlyContinue
	Start-Sleep -Seconds 1
}

$timer.Stop()

if ($process -eq $None){
	exit 1
}

$process.WaitForExit()
exit 0