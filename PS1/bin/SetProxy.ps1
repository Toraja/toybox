param(
    [Parameter(Mandatory = $true)]
    [string] $ProxyServer
)

function toast {
    param(
        [string]$message,
        [string]$title = "Notification"
    )

    Add-Type -AssemblyName System.Windows.Forms

    $global:balloon = New-Object System.Windows.Forms.NotifyIcon
    $path = Get-Process -id $pid | Select-Object -ExpandProperty Path
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    $balloon.BalloonTipIcon = "Info"
    $balloon.BalloonTipText = "$message"
    $balloon.BalloonTipTitle = "$title"
    $balloon.Visible = $true
    $balloon.ShowBalloonTip(5000)
}

$RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

$currentProxy = (Get-ItemProperty -Path "$RegistryPath" -ErrorAction Stop).AutoConfigURL

if ("$currentProxy" -ne "$ProxyServer") {
    Set-ItemProperty -Path $RegistryPath -Name AutoConfigURL -Value $ProxyServer
    $msg = "Proxy has been changed from '$currentProxy' to '$ProxyServer'"
    Write-Host "$msg"
    toast -message "$msg" -title "Proxy Server Changed"
}
