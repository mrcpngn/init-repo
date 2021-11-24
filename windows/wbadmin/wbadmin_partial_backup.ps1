# Create a backup policy
$Policy = New-WBPolicy
# Set system state as a backup source to a policy
Add-WBSystemState -Policy $Policy
# Bare metal backup set to policy as a recovery method
Add-WBBareMetalRecovery -Policy $Policy
# add source files/folders/volumes to take backup to the backup policy
# example follows specifies C dirive all
New-WBFileSpec -FileSpec "C:" | Add-WBFileSpec -Policy $Policy
# if multiple drives exist, possible to add
New-WBFileSpec -FileSpec "D:" | Add-WBFileSpec -Policy $Policy

# set Volume Shadow Copy Service (VSS) option to the backup policy

Set-WBVssBackupOptions -Policy $Policy -VssCopyBackup
# set backup tagret Path
# example below specifies remote shared folder
# -NetworkPath (remote shared folder)
# -Credential (PSCredential for shared folder)
# specify a user who can access to shared and also who has wirte privilege to it
# example follows specifies a user/password [Serverworld/P@ssw0rd01]
$BackupLocation = New-WBBackupTarget -NetworkPath "\\10.1.2.4\f" `
-Credential (New-Object PSCredential("azureuser", (ConvertTo-SecureString -AsPlainText "azureuserHelp123!" -Force)))

# add backup tagret to the backup policy
Add-WBBackupTarget -Policy $Policy -Target $BackupLocation

# confirm configured backup policy
$Policy

# run backup
Start-WBBackup -Policy $Policy

# confirm backup history
Get-WBSummary