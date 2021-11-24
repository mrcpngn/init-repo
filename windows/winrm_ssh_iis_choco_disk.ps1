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

#Install OpenSSH
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*';
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0;          # Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0;          # Install the OpenSSH Server
Start-Service sshd;                                                     # Start the sshd service
Set-Service -Name sshd -StartupType 'Automatic';                        # OPTIONAL but recommended:
Get-NetFirewallRule -Name *ssh*;                                        #Confirm the firewall rule is configured. It should be created automatically by setup.

# There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled
# If the firewall does not exist, create one
#New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22;


#Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

#Install mariadb
choco install -y mariadb.install --version=10.4.6;
#Install mariadb and set mysql.exe as env variable
powershell.exe $env:Path += 'C:/Program Files/MariaDB 10.4/bin/mysql.exe'

#Attach Data Disk
$disks = Get-Disk | Where partitionstyle -eq 'raw' | sort number;
$letters = 70..89 | ForEach-Object { [char]$_ };
$count = 0;
$labels = "DATA1","DATA2";
foreach ($disk in $disks) {
    $driveLetter = $letters[$count].ToString()
    $disk | 
    Initialize-Disk -PartitionStyle MBR -PassThru |
    New-Partition -UseMaximumSize -DriveLetter $driveLetter |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel $labels[$count] -Confirm:$false -Force
    $count++
};