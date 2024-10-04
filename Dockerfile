FROM ubuntu:20.04 as base

RUN apt-get update && \
apt-get install wget -y && \
mkdir /Data && \
chmod 0777 /Data && \
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O /Data/packages-microsoft-prod.deb && \
dpkg -i  /Data/packages-microsoft-prod.deb && \
rm /Data/packages-microsoft-prod.deb && \
apt-get update && \
apt-get install --no-install-recommends dotnet-sdk-2.1 dotnet-sdk-3.1 dotnet-sdk-5.0 dotnet-sdk-6.0 -y && \
apt-get install --no-install-recommends openssh-server sudo apt-transport-https -y && \
apt-get install --no-install-recommends libgdiplus libharfbuzz0b libicu-dev libfontconfig1 libfreetype6 libpango-1.0-0 libpangocairo-1.0 -y && \
apt-get autoremove -y && \
apt-get purge -y && \
rm -rf /var/lib/apt/lists/* && \
wget https://support.movicon.com/download/Movicon_DeployServer/latest/DeployServer.tar.gz -O /Data/DeployServer.tar.gz && \
tar -xf /Data/DeployServer.tar.gz --directory /Data/ && \
rm /Data/DeployServer.tar.gz && \
sed 's\"User": ""\"User": "MoviconUser@emerson.com"\' /Data/DeployServer/appsettings.json > /Data/DeployServer/appsettings.json_u && \
sed 's\"Password": ""\"Password": "MyPwd123!"\' /Data/DeployServer/appsettings.json_u > /Data/DeployServer/appsettings.json_p && \
sed 's\"Path": ""\"Path": "/Data/Projects/"\' /Data/DeployServer/appsettings.json_p > /Data/DeployServer/appsettings.json && \
rm /Data/DeployServer/appsettings.json_u && \
rm /Data/DeployServer/appsettings.json_p && \
dotnet dev-certs https && \
dotnet dev-certs https --trust && \
echo '#!/bin/bash' > /Data/start.sh && \
echo '/usr/share/dotnet/dotnet dev-certs https' >> /Data/start.sh && \
echo '/usr/share/dotnet/dotnet /Data/DeployServer/DeployServer.dll' >> /Data/start.sh && \
chmod a+x /Data/start.sh
EXPOSE 5000 5001 5002 62841
CMD ["/Data/start.sh"]