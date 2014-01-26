#!

################################################################################
#
# Title:        down-easyb.sh
# Description:  Remove Hudson
# Author:       Matthew Norris
#
################################################################################

installPrefix=/opt/dev/tools
installDirName="easyb"

# Friendly names
friendlyName="Easyb"
friendlyLinkName="easyb"

echo "Removing $friendlyName..."
sudo rm /usr/local/$installDirName
sudo rm -dr $installPrefix/$installDirName
echo "Done."