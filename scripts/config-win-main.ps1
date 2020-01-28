## SCRIPT FOR MAIN BOX
## command to call: 

Param(
    [string]$ts_admin_un,
    [string]$ts_admin_pw,
    [string]$reg_first_name,
    [string]$reg_last_name,
    [string]$reg_email,
    [string]$reg_company,
    [string]$reg_title,
    [string]$reg_department,
    [string]$reg_industry,
    [string]$reg_phone,
    [string]$reg_city,
    [string]$reg_state,
    [string]$reg_zip,
    [string]$reg_country,
    [string]$license_key,
    [string]$install_script_url,
    [string]$local_admin_user,
    [string]$local_admin_pass,
    [string]$eula
)

### FILES

## 1. make secrets.json file
Set-Location "C:\"
mkdir tab

$secrets = @{
    local_admin_user = $local_admin_user
    local_admin_pass = $local_admin_pass
    content_admin_user = $ts_admin_un
    content_admin_pass = $ts_admin_pw
    product_keys = @($license_key)
}

$secrets | ConvertTo-Json -depth 10 | Out-File "C:\tab\sc.json" -Encoding ASCII

## 2. make registration.json
#TODO: add parameter for accepting eula
$registration = @{
    first_name = $reg_first_name
    last_name = $reg_last_name
    email = $reg_email
    company = $reg_company
    title = $reg_title
    department = $reg_department
    industry = $reg_industry
    phone = $reg_phone
    city = $reg_city
    state = $reg_state
    zip = $reg_zip
    country = $reg_country
    eula = "yes"
}

$registration | ConvertTo-Json -depth 10 | Out-File "C:\tab\rg.json" -Encoding ASCII

## 3. Create config file
$config = @{
    configEntities = @{
        identityStore= @{
            _type= "identityStoreType"
            type= "local"
        }
    }
    topologyVersion = @{}
}

$config | ConvertTo-Json -depth 20 | Out-File "C:\tab\cf.json" -Encoding ASCII

## 4. Download scripted installer .py (refers to Tableau's github page) - replace with variable
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/maddyloo/tableau-server-single-node/master/scripts/SilentInstaller.py" -OutFile "C:\tab\SI.py" -UseBasicParsing

## 5. Download python .exe
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.7.0/python-3.7.0.exe" -OutFile "C:\tab\python-3.7.0.exe" -UseBasicParsing

## 6. Download Tableau Server 2019.4 .exe
Invoke-WebRequest -Uri "https://downloads.tableau.com/esdalt/2019.4.1/TableauServer-64bit-2019-4-1.exe" -OutFile "C:\tab\ts.exe" -UseBasicParsing

### COMMANDS

## 1. Install python (and add to path) - wait for install to finish
Start-Process -FilePath "C:\tab\python-3.7.0.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait

## 2. Open port 8850 for TSM access & 80 for Tableau Server access
New-NetFirewallRule -DisplayName "TSM Inbound" -Direction Inbound -Action Allow -LocalPort 8850 -Protocol TCP
New-NetFirewallRule -DisplayName "Tableau Server Inbound" -Direction Inbound -Action Allow -LocalPort 80 -Protocol TCP

## 3. Start SMB/file share on c drive
New-SMBShare -Name "psexec" -Path "C:\" -FullAccess "locadmin"