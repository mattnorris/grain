#!/bin/bash

################################################################################
#
# Title:        down-openlaszlo.sh
# Description:  Remove OpenLaszlo
# Author:       Matthew Norris
#
################################################################################

# Default install directory & app names
laszloVersion="4.6.1"
installDirName="lps-$laszloVersion"
installPrefix="/opt/dev/sdks"

echo "Removing OpenLazslo..."

sudo rm /usr/local/$installDirName
sudo rm -fr $installPrefix/$installDirName

echo "Done."