# Variables
$winrm = Test-WSMan
$fw_winrm_http = Get-NetFirewallRule -Name WinRM-HTTP

# Check WinRM Connection
$winrm

if ( $? -eq $True )
{
  Write-Host "WinRM configuration is enabled"
}
else
{
  Enable-PSRemoting -force;
  winrm set winrm/config '@{MaxTimeoutms="1800000"}';
  winrm set winrm/config/service '@{AllowUnencrypted="true"}';
  winrm set winrm/config/service/auth '@{Basic="true"}';
}

# Check WinRM Firewall rule
$fw_winrm_http

if ( $? -eq $True )
{
  Write-Host "Firewall rule for WinRM connection is enabled"
}
else
{
  netsh advfirewall firewall add rule name=”WinRM-HTTP” dir=in localport=5985 protocol=TCP action=allow;
}
