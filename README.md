# Tableau Server Single Node
<img src="https://github.com/maddyloo/tableau-server-single-node/blob/master/images/tableau_rgb.png"/>
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2F100-blank-template%2Fazuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2F100-blank-template%2Fazuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>

This template deploys a **single node Tableau Server instance on a Standard_D16_v3 VM instance running Ubuntu 16.04.0-LTS** in its own Virtual Network.

`Tags: Tableau, Tableau Server, Business Intelligence, Analytics, Self-Service, Data Visualization`

## Tableau Server and deployed resources overview

Tableau Server on Azure is browser and mobile-based visual analytics anyone can use.  Publish interactive dashboards with Tableau Desktop and share them throughout your organization. Embedded or as a stand-alone application, you can empower your business to find answers in minutes, not months.  By deploying Tableau Server on Azure with this quickstart you can take full advantage of the power and flexibility of Azure Cloud infrastructure.  

Tableau helps people see and understand their data by making it simple for the everyday data worker to perform ad-hoc visual analytics and data discovery as well as the ability to seamlessly build beautiful dashboards and reports. Tableau is designed to make connecting live to data of all types a simple process that doesn't require any coding or scripting. From cloud sources like Azure SQL Data Warehouse, to on-premise Hadoop clusters, to local spreadsheets, Tableau gives everyone the power to quickly start visually exploring data of any size to find new insights.

The following resources are deployed as part of the solution

#### Tableau

Tableau Server 2019.1 is deployed via the config-linux.sh script.  This config-linux.sh script performs several configuration tasks upon deployment including creating registration & configuration files, configuring firewall rules and perfomring a completely silent install of Tableau Server using an additional script located <a href="https://github.com/tableau/server-install-script-samples/tree/master/linux/automated-installer">here</a>

Each of these scripts can be called manually and customized by users.  To call the config-linux.sh script manually sue the following command:

Bash:
```bash
sh ./config-linux.sh -u <vm_username> -p <vm_password> -h <tableau_server_admin_UN> -i <tableau_server_admin_UN> -j <zip_code> -k <country> -l <city> -m <last_name> -n <industry> -o yes -q <job_title> -r <phone_number> -s <company_name> -t <state> -v <department> -w <first_name> -x <email_address>
```

#### Microsoft Azure

This template deploys the following Azure resources.  For information on the cost of these resources please use the pricing calculator found here: https://azure.microsoft.com/en-us/pricing/calculator/

<img src="https://github.com/maddyloo/tableau-server-single-node/blob/master/images/azure_single_node.png"/>

+ **Virtual Network**: New (or existing) virtual network that contains all relevant resources required by the Tableau Server install
+ **Virtual Machine**: Standard_D16-v3 instance
+ **Network Interface**: Allows Azure VM to communicate with the internet
+ **Public IP Address**: Static Public IP that allows users to access Tableau Server
+ **Network Security Group**: Limits traffic to Azure VM (RDP/SSH & port 80/22 only)

## Prerequisites

By default this template will install a 12-day free trial of Tableau Server.  To switch to a licensed version please contact your Tableau Sales representative.  

## Deployment steps

You can click the "Deploy to Azure" button at the beginning of this document or follow the following instructions for command line deployment using the scripts in the root of this repo.

To deploy this template using the scripts from the root of this repo: 

Powershell:
```PowerShell
.\Deploy-AzureResourceGroup.ps1 -ResourceGroupLocation 'west us' -ArtifactsStagingDirectory 'tableau-server-single-node' -UploadArtifacts 
```
Bash:
```bash
azure-group-deploy.sh -a tableau-server-single-node -l westus -u
```

## Usage

The following parameters require input to customize your isntallation of Tableau Server:

+ **adminUsername**:
+ **adminPassword**:
+ **tableau_admin_password**:
+ **tableau_admin_username**:
+ **OS**:
+ **registration_first_name**:
+ **registration_last_name**:
+ **registration_email**:
+ **registration_company**:
+ **registration_title**:
+ **registration_department**:
+ **registration_industry**:
+ **registration_phone**:
+ **registration_city**:
+ **registration_state**:
+ **registration_zip**:
+ **registration_country**:
+ **source_CIDR**:

#### Connect

Navigate to Tableau Server using the public IP address: http://- Public IP -:80

If you are a Tableau Server admin then you can navigate to http://- Public IP -:8850 to access Tableau Services Manager to perform admin tasks: https://onlinehelp.tableau.com/current/server-linux/en-us/tsm_overview.htm

#### Management

Manage your Azure resources directly from your Azure portal.  Use the web UI and Desktop Interface to adminsitrate your Tableau Server instance: https://onlinehelp.tableau.com/current/server/en-us/admin.htm

If you are a machine admin then you can SSH directly into the machine as necessary to make changes to the system, upgrade, apply patches, etc.  In day-to-day practice Tableau Server does not require you to monitor the machine directly.

## Notes

Follow these requirements when setting parameters: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/faq#what-are-the-username-requirements-when-creating-a-vm

This template is intended as a sample for how to install Tableau Server.  If you choose to run a production version of Tableau Server you are responsible for managing the cost & security of your Azure & Tableau deployment.  This version has been written by Madeleine Corneli and is not officially endorsed by Tableau Software.