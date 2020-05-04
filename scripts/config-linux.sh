#!/bin/bash

# confirmed: this script works when run manually as root user from root top directory using the following command
# sh ./config-linux.sh -u <username> -p <password> -h admin -i admin -j 98107 -k usa -l seattle -m data -n tech -o yes -q pm -r 8888888 -s tableau -t wa -v dev -w jamie -x jdata@tableau.com [-y <license key>]
# customized to reflect machine admin username and admin password

while getopts e:f:g:h:i:j:k:l:m:n:o:p:q:r:s:t:u:v:w:x:y: option
do
 case "${option}"
 in
 e) VERSION=${OPTARG};;
 f) OS=${OPTARG};;
 g) INSTALL_SCRIPT_URL=${OPTARG};;
 h) TS_USER=${OPTARG};;
 i) TS_PASS=${OPTARG};;
 j) ZIP=${OPTARG};;
 k) COUNTRY=${OPTARG};;
 l) CITY=${OPTARG};;
 m) LAST_NAME=${OPTARG};;
 n) INDUSTRY=${OPTARG};;
 o) EULA=${OPTARG};;
 p) PASSWORD=${OPTARG};;
 q) TITLE=${OPTARG};;
 r) PHONE=${OPTARG};;
 s) COMPANY=${OPTARG};;
 t) STATE=${OPTARG};;
 u) USER=${OPTARG};;
 v) DEPARMENT=${OPTARG};;
 w) FIRST_NAME=${OPTARG};;
 x) EMAIL=${OPTARG};;
 y) LICENSE_KEY=${OPTARG};;
esac
done

cd /tmp/

#ADDED: create log file
touch install.log

# create secrets
printf "tsm_admin_user=\"$USER\"\ntsm_admin_pass=\"$PASSWORD\"\ntableau_server_admin_user=\"$TS_USER\"\ntableau_server_admin_pass=\"$TS_PASS\"" >> secrets | tee -a install.log

# create registration file
echo "{
 \"zip\" : \"$ZIP\",
 \"country\" : \"$COUNTRY\",
 \"city\" : \"$CITY\",
 \"last_name\" : \"$LAST_NAME\",
 \"industry\" : \"$INDUSTRY\",
 \"eula\" : \"$EULA\",
 \"title\" : \"$TITLE\",
 \"phone\" : \"$PHONE\",
 \"company\" : \"$COMPANY-azure-arm-linux\",
 \"state\" : \"$STATE\",
 \"department\" : \"$DEPARMENT\",
 \"first_name\" : \"$FIRST_NAME\",
 \"email\" : \"$EMAIL\"
}" >> registration.json | tee -a install.log

# create config file
echo '{
  "configEntities": {
    "identityStore": {
      "_type": "identityStoreType",
      "type": "local"
    }
  }
}' >> config.json | tee -a install.log
wait

# assemble download URI
hyphen=`echo $VERSION | tr '.' '-'`

# download tableau server .deb or.rpm file & retry on fail
if [ "$OS" == "Ubuntu 16.04 LTS" ]
then
  wget --tries=3 --output-document=tableau-installer.deb "https://downloads.tableau.com/esdalt/${VERSION}/tableau-server-${hyphen}_amd64.deb" | tee -a install.log
else
  wget --tries=3 --output-document=tableau-installer.rpm "https://downloads.tableau.com/esdalt/${VERSION}/tableau-server-${hyphen}.x86_64.rpm" | tee -a install.log
fi

if [ $? -ne 0 ]
then
  echo "wget of Tableau installer failed" >> install.txt
  exit 1;
fi

# download automated-installer
wget --remote-encoding=UTF-8 --output-document=automated-installer.sh $INSTALL_SCRIPT_URL | tee -a install.log
                                                              
wait
chmod +x automated-installer.sh | tee -a install.log

echo "modified automated-installer" >> installer_log.txt | tee -a install.log

# ensure everything is finished
wait

# run automated installer (install trial if no license key)
# if [ -z "$LICENSE_KEY" ]
#convert trial to lower?
if [ "$LICENSE_KEY" == "trial" ]
then
  if [ "$OS" == "Ubuntu 16.04 LTS" ]
  then
    sudo ./automated-installer.sh -s secrets -f config.json -r registration.json -a "$USER" --accepteula tableau-installer.deb --force | tee -a install.log
  else
    sudo ./automated-installer.sh -s secrets -f config.json -r registration.json -a "$USER" --accepteula tableau-installer.rpm --force | tee -a install.log     
  fi
else
  if [ "$OS" == "Ubuntu 16.04 LTS" ]
  then
    sudo ./automated-installer.sh -s secrets -f config.json -r registration.json -a "$USER" -k "$LICENSE_KEY" --accepteula tableau-installer.deb --force | tee -a install.log
  else
    sudo ./automated-installer.sh -s secrets -f config.json -r registration.json -a "$USER" -k "$LICENSE_KEY" --accepteula tableau-installer.rpm --force | tee -a install.log
  fi
fi

wait

# if on RHEL, open firewall
# on some RHEL versions, need to yum install firewalld?
if [ "$OS" == "RHEL 7.6" ] || [ "$OS" == "CentOS 7.5" ]
then
  firewall-cmd --zone=public --add-port=80/tcp --permanent | tee -a install.log
  firewall-cmd --reload | tee -a install.log
fi

# remove all install files
rm registration.json | tee -a install.log
rm secrets | tee -a install.log
if [ "$OS" == "RHEL 7.6" ] || [ "$OS" == "CentOS 7.5" ]
then
  rm tableau-installer.rpm | tee -a install.log
else
  rm tableau-installer.deb | tee -a install.log
fi
rm automated-installer.sh | tee -a install.log
rm config.json | tee -a install.log