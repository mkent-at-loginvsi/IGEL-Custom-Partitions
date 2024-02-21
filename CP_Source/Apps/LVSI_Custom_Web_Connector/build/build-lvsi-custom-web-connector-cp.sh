#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for lvsi-custom-web-connector
## Development machine (Ubuntu 18.04)

sudo apt install unzip -y

mkdir build_tar
cd build_tar

MISSING_LIBS="git npm libnss3 libxss1 libasound2 libatk-bridge2.0-0 libgtk-3-0 libgbm-dev"
for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/lvsi-custom-web-connector

find . -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/lvsi-custom-web-connector
done

wget https://github.com/mkent-at-loginvsi/IGEL-Custom-Partitions/raw/main/CP_Packages/Apps/LVSI_Custom_Web_Connector/LVSI_Custom_Web_Connector.zip

unzip LVSI_Custom_Web_Connector.zip -d custom
mv custom/target/build/lvsi-custom-web-connector-cp-init-script.sh custom

cd custom

# edit inf file for version number
#mkdir getversion
#cd getversion

#tar xf control.tar.* ./control
#VERSION=$(grep Version control | cut -d " " -f 2)
#echo "Version is: " ${VERSION}
#cd ..
#sed -i "/^version=/c version=\"${VERSION}\"" target/lvsi-custom-web-connector.inf


# new build process into zip file
tar cvjf target/lvsi-custom-web-connector.tar.bz2 lvsi-custom-web-connector lvsi-custom-web-connector-cp-init-script.sh
zip -g ../LVSI_Custom_Web_Connector.zip target/lvsi-custom-web-connector.tar.bz2 target/lvsi-custom-web-connector.inf
zip -d ../LVSI_Custom_Web_Connector.zip "target/build/*" "target/igel/*" "target/target/*"
mv ../LVSI_Custom_Web_Connector.zip ../../LVSI_Custom_Web_Connector-${VERSION}_igel01.zip

cd ../..
#rm -rf build_tar