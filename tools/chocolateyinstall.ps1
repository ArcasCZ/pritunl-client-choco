$Timeout = 20

$ErrorActionPreference = 'Stop';

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/pritunl/pritunl-client-electron/releases/download/1.3.3785.81/Pritunl.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  softwareName  = 'pritunl client*'
  checksum      = 'd5602a199d2f1bb3dc43f8eb94c2b02175f4668eb8beb7e6860713024025cb33'
  checksumType  = 'sha256'
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0,1)
}

# If Pritunl is already installed and running, we have to
# kill the process. Otherwise the files won't be overwritten.

Get-Process pritunl -ErrorAction SilentlyContinue | Stop-Process -Force

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