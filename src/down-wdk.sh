#!

################################################################################
# Title:        down-wdk.sh
# Description:  Remove Yahoo TV Widget Development Kit
# Author:       Matthew Norris
# Reference:    http://linux.about.com/od/ubuntu_doc/a/ubudg21t2.htm
#
################################################################################

verbose=false

#utilDir="$HOME/scripts/util"
utilDir="../util"

# Location to download source files
defDownloadDir=$HOME/sources
dlDir=$defDownloadDir

# Location to install
defInstallPrefix=/opt/dev/sdks
#defInstallPrefix=$HOME/dev/sdks
installPrefix=$defInstallPrefix

# Linux group (used for permissions)
group=developers

# Download files

dlPrefix="http://connectedtv.yahoo.com/developer/wdk/download"
dlFileName="wdk"
dlFileExt="zip"

# Default install directory name
installDirName="wdk"

# Friendly name for messages
friendlyName="Widget Development Kit"


# Simulator global widget directory
gWidgetDir="devwidgets"
lWidgetDir="TVWidgets"

# Package name
pkgPrefix="ywe-wdk"
pkgVersion="0.9.7.6"
pkgArch="i386"
pkgExt="deb"

pkgName="${pkgPrefix}_${pkgVersion}_${pkgArch}"

# Default install directory name (notice the subtle difference)
installDirName="${pkgPrefix}-${pkgVersion}-${pkgArch}"

###############################################################################
# Functions
###############################################################################

function errorMessage() {
    echo -e "Error: $1"
    exit 1
}

###############################################################################
# Main
###############################################################################

# Check for the proper utilities

if [[ ! -f "$utilDir/mmkdir.sh" ]] || [[ ! -f "$utilDir/marmdir.sh" ]]; then
    errorMessage "Utilities not found in '$utilDir'. Please specify the proper directory."
fi

# Archive any widgets
echo "Archiving $lWidgetDir and $gWidgetDir..."
sudo $utilDir/marmdir.sh $HOME/$lWidgetDir $HOME/uninstall
sudo $utilDir/marmdir.sh "/${gWidgetDir}" $HOME/uninstall
echo "Done."

# Remove package
echo "Removing $pkgPrefix..."
sudo dpkg -r $pkgPrefix
echo "Done."

# Remove SDK folder
echo "Removing $installDirName..."
sudo rm -dr $installPrefix/$installDirName
echo "Done."

# Remove dependencies
echo "Removing dependencies..."
sudo aptitude remove expect -y
sudo aptitude remove libsdl-image1.2 -y
sudo aptitude remove lib32readline5 -y
echo "Done."
