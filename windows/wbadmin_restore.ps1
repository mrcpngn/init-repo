# Perform Restore of backup files
$Backup = Get-WBBackupSet
Start-WBSystemStateRecovery -BackupSet $Backup -Force -Async

#View the Job Status
while (1) {Get-WBJob | Select-Object -Property  CurrentOperation, JobState; sleep 5}