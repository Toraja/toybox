param(
    [Parameter(Mandatory = $true)] [string] $File,
    [Parameter(Mandatory = $true)] [string] $Checksum
)

$FileChkSUm = $(Get-FileHash -Path $File -Algorithm MD5).Hash

if($FileChkSUm -eq $Checksum){
    Write-Host -Object "Checksum matches." -ForegroundColor Cyan
}
else{
    Write-Host -Object "Checksum does not match." -ForegroundColor Yellow
    Write-Host -Object $FileChkSUm
}
