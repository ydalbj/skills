# Requires -RunAsAdministrator
# Only works for WSL v2,  this is completely not needed for WSL v1 where u always can use 127.0.0.1 in hosts file

Clear-Host

if ((Get-InstalledModule "Carbon" -ErrorAction SilentlyContinue) -eq $null) {
    Install-Module -Name 'Carbon' -AllowClobber
}

Import-Module 'Carbon'

#$wslIp = (wsl hostname -I) -replace ' ',''
$ips = wsl hostname -I

$wslIp = $ips.SubString(0, $ips.IndexOf(' '))

Write-Host "Setting wsl v2 hosts entries to $wslIp"

$domains = @(
	'wsl2.local',
	'shop70.test',
    'shop5.test',
	'shop3.test',
    'shop2.test'
    # add more domains if necessary
)

foreach($domain in $domains) {
    Set-HostsEntry -IPAddress $wslIp -HostName $domain
}

Write-Host "Done!"