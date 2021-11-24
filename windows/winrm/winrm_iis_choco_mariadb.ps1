#Enable and config WinRM
Enable-PSRemoting -force;
winrm set winrm/config '@{MaxTimeoutms="1800000"}';
winrm set winrm/config/service '@{AllowUnencrypted="true"}';
winrm set winrm/config/service/auth '@{Basic="true"}';
netsh advfirewall firewall add rule name=”WinRM-HTTP” dir=in localport=5985 protocol=TCP action=allow;

#Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools;
#Insert hostname
$HOSTNAME=hostname;
echo "$HOSTNAME" > C:/inetpub/wwwroot/index.html;

#Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

#Install mariadb
choco install -y mariadb.install --version=10.4.6;
#Install mariadb and set mysql.exe as env variable
powershell.exe $env:Path += 'C:/Program Files/MariaDB 10.4/bin/mysql.exe'