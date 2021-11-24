#Enable and config WinRM
Enable-PSRemoting -force;
winrm set winrm/config '@{MaxTimeoutms="1800000"}';
winrm set winrm/config/service '@{AllowUnencrypted="true"}';
winrm set winrm/config/service/auth '@{Basic="true"}';
netsh advfirewall firewall add rule name=”WinRM-HTTP” dir=in localport=5985 protocol=TCP action=allow;