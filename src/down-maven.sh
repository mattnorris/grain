#!

################################################################################
#
# Title:        up-maven.sh
# Description:  Install Maven 2 for use with Java & Grails
# Author:       Matthew Norris
# References:   http://grails.org/Maven+Integration
#
################################################################################

# Installation location
installPrefix=/opt/dev/tools

# Default install directory name
installDirName="apache-maven-2.2.1"

# Friendly names
friendlyName="Maven 2"
friendlyLinkName="maven"

echo "Removing $friendlyName..."
sudo rm /usr/local/bin/mvn
sudo rm $installPrefix/$friendlyLinkName
sudo rm -dr $installPrefix/$installDirName
echo "Done."
