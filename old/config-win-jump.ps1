## SCRIPT FOR JUMPBOX
## command to call: config-win-jump.ps1 -ts_main_ip [ip address] -local_admin_user [local admin username -local_admin_pass [local admin password]

Param(
    [string]$ts_main_IP,
    [string]$local_admin_user,
    [string]$local_admin_pass
)

# 1. download PsTools.zip
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/PSTools.zip" -OutFile "C:\PSTools.zip" -UseBasicParsing

# 2. Unzip PSTools.zip
Expand-Archive -LiteralPath "C:\PSTools.zip" -Destination "C:\PSTools\"

# & 'C:\PSTools\PsExec.exe' \\$ts_main_IP -u $local_admin_user -p $local_admin_pass PowerShell -accepteula

# 3. start PsExec, accept eula, run command
& 'C:\PSTools\PsExec.exe' \\$ts_main_IP -u $local_admin_user -p $local_admin_pass -accepteula python 'C:\tab\SI.py' "install" 'C:\tab\ts.exe' --secretsFile "C:\tab\sc.json" --configFile "C:\tab\cf.json" --registrationFile "C:\tab\rg.json" --start "yes"

# n. Stop SMB/file share on c drive
# n. remove sc.json