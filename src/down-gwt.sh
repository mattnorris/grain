#!/bin/bash

################################################################################
#
# Title:        down-gwt.sh
# Description:  Remove Google Web Toolkit
# Author:       Matthew Norris
#
################################################################################

# Name to display
friendlyName="Google Web Toolkit"

# Installation location
installPrefix=/opt/dev/sdks

# Default install directory name
installDirName="gwt-linux-1.7.1"

echo "Removing $friendlyName..."
#sudo rm /usr/local/bin/mvn
sudo rm -dr $installPrefix/$installDirName
echo "Done."
