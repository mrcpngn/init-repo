
#Enable and config WinRM
Enable-PSRemoting -force;
winrm set winrm/config '@{MaxTimeoutms="1800000"}';
winrm set winrm/config/service '@{AllowUnencrypted="true"}';
winrm set winrm/config/service/auth '@{Basic="true"}';
netsh advfirewall firewall add rule name=”WinRM-HTTP” dir=in localport=5985 protocol=TCP action=allow;

#Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools;

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