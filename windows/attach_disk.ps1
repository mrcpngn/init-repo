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