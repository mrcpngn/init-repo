# Install-WindowsFeature Windows-Server-Backup;
# Install-WindowsFeature -name Web-Server -IncludeManagementTools;

# Backup Image stored Volume
$dst_path = "\\nas-jpe-vm-1\F" # Network path of the Driveletter/Folder
# Backup images will be stored under "<DriveLetter>:\WindowsImageBackup\<hostname>"

# Create a backup policy
$wb_policy = New-WBPolicy

# Set system state as a backup source to a policy
Add-WBSystemState -Policy $wb_policy

# Bare metal backup set to policy as a recovery method
Add-WBBareMetalRecovery -Policy $wb_policy

# Set backup destination to policy (for local disk)
#Add-WBBackupTarget -Policy $wb_policy (New-WBBackupTarget -VolumePath $dst_path) -Force

# Set backup destination to policy (network path)
Add-WBBackupTarget -Policy $wb_policy (New-WBBackupTarget -NetworkPath $dst_path) -Force

# Specify VSS copy backup as VSS backup option
Set-WBVssBackupOptions -Policy $wb_policy -VssCopyBackup

# Run Backup
Start-WBBackup -Policy $wb_policy -Force -Async

# Get the state at the start of the backup job
$start_job_state = Get-WBJob

# Get the last backup job
$last_job_state = Get-WBJob -Previous 1

# Wait for the backup job to complete
while ($start_job_state.StartTime -ne $last_job_state.StartTime) {
    Start-Sleep -s 30
    $last_job_state = Get-WBJob -Previous 1
}

# Backup result determination
if ($last_job_state.HResult -eq 0) {
    # Successful backup job
    exit 0
} else {
    # Backup job abort termination
    exit -1
}

