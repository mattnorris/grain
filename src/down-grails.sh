#!

################################################################################
#
# Title:        down-grails.sh
# Description:  Remove Grails
# Author:       Matthew Norris
#
################################################################################

installPrefix=/opt/dev/sdks

# Friendly names
friendlyName="Grails"
friendlyLinkName="grails"

echo "Removing $friendlyName..."
sudo rm $installPrefix/$friendlyLinkName
sudo rm -fr $installPrefix/grails-1.1.1
echo "Done."