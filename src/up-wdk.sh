#!

################################################################################
# Title:        up-wdk.sh
# Description:  Setup Yahoo TV Widget Development Kit
# Author:       Matthew Norris
# Reference:    http://connectedtv.yahoo.com/developer/wdk/download
#               http://ubuntuforums.org/showpost.php?p=7079256&postcount=18
#               http://www.mathlinks.ro/viewtopic.php?t=272131
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

# Friendly name for messages
friendlyName="Widget Development Kit"


# Simulator global widget directory
widgetDir="/devwidgets"

# Package name
pkgPrefix="ywe-wdk"
pkgVersion="0.9.7.6"
pkgArch="i386"
pkgExt="deb"

pkgName="${pkgPrefix}_${pkgVersion}_${pkgArch}"

# Default install directory name (notice the subtle difference)
installDirName="${pkgPrefix}-${pkgVersion}-${pkgArch}"

################################################################################
# Functions
################################################################################

function checkUtilDir() {

    # Strip whitespace
    utilDir=$(expr "$1" : '[[:space:]]*\(.*\)[[:space:]]*$')
    
    # Check for null and whitespace
    if [[ -z "$utilDir" ]] || [[ ! -n "$utilDir" ]]; then
        errorMessage "No UTIL DIRECTORY specified. Try --help for help."
    fi
    
    if [[ ! -d $utilDir ]]; then
        errorMessage "$utilDir does not exist."
    fi
}

function checkDirs() {
    
    # Strip whitespace and remove any trailing slashes
    installPrefix=$(expr "$1" : '[[:space:]]*\(.*\)[[:space:]]*$' | sed -e 's/\\/$//g')
    dlDir=$(expr "$2" : '[[:space:]]*\(.*\)[[:space:]]*$' | sed -e 's/\\/$//g')
    
    # Check for null and whitespace
    if [[ -z "$installPrefix" ]] || [[ ! -n "$installPrefix" ]]; then
        warningMessage "No INSTALL DIRECTORY specified. Using default: $defInstallPrefix"
        installPrefix=$defInstallPrefix
    fi
    
    if [[ -z "$dlDir" ]] || [[ ! -n "$dlDir" ]]; then
        warningMessage "No DOWNLOAD DIRECTORY specified. Using default: $defDownloadDir"
        dlDir=$defDownloadDir
    fi
    
    # Do the specified directories exist?
    if [[ ! -d $installPrefix ]]; then 
        errorMessage "$installPrefix is not a directory. Try '$(basename $0) --help' for help."
    fi
    
    if [[ ! -d $dlDir ]]; then 
        errorMessage "$dlDir is not a directory. Try '$(basename $0) --help' for help."
    fi
}

function checkParamStr() {
    # If there are no parameters, throw error
    if [[ "${#1}" -eq "0" ]]; then
        errorMessage "Try '$(basename $0) --help' for help."
    fi
}

function errorMessage() {
    echo -e "Error: $1"
    exit 1
}

function warningMessage() {
    echo -e "Warning: $1"
}

function outputUsage() {
    echo "up-wdk - Install $friendlyName"
    echo "Usage: $(basename $0) [options...] [INSTALL DIRECTORY] [DOWNLOAD DIR]"
    echo "Options:"
    echo "  -v/--verbose   Not yet implemented"
    echo "  -h/--help      Output this message"
    
    exit 1
}

function installPkg() {
    # Since we have a 64-bit system, force 32-bit architecture
    sudo dpkg -i --force-architecture "$installPrefix/$installDirName/${pkgName}.${pkgExt}"
}

################################################################################
# Command line processing
################################################################################

# Parse the command line arguments
while [[ "$#" -gt "0" ]]; do
    case "$1" in 
        -v|--verbose)
            verbose=true
            shift 1
            checkParamStr "$@"
            ;;
        -h|--help)
            outputUsage
            ;;
        -*|--*)
            # Unknown option
            errorMessage "Unknown option $1."
            ;;
        *)
            # If we have more than 2 parameters, the usage is incorrect
            if [[ "$#" -gt "2" ]]; then
                errorMessage "Too many parameters. Try '$(basename $0) --help' for help."
            else
                checkDirs $1 $2
                shift 2
            fi
            break
            ;;
    esac
done

################################################################################
# Main
###############################################################################

# Check for the proper utilities

if [[ ! -f "$utilDir/mmkdir.sh" ]] || [[ ! -f "$utilDir/marmdir.sh" ]]; then
    errorMessage "Utilities not found in '$utilDir'. Please specify the proper directory."
fi

$utilDir/mmkdir.sh $dlDir
echo

# Download Yahoo WDK zip and inflate it

echo $dlDir 
echo "$dlPrefix/$dlFileName.$dlFileExt"

echo "Downloading $dlFileName.$dlFileExt..."
if [[ ! -f $dlDir/$dlFileName.$dlFileExt ]]; then
	wget --directory-prefix=$dlDir "$dlPrefix/$dlFileName.$dlFileExt"
	if [ $? -eq 0 ]; then
	    echo "Done."
	else
	   errorMessage "Download failed with exit status of $?"
	fi
else
    echo "$dlFileName.$dlFileExt has already been downloaded."
fi
echo

echo "Installing $friendlyName to $installPrefix..."

# Check for archive type

if [[ "${dlFileExt}" == "zip" ]]; then 
	sudo unzip -q $dlDir/$dlFileName.$dlFileExt -d $installPrefix
elif [[ "${dlFileExt}" == "tar.gz" ]]; then
    sudo tar -zxf $dlDir/$dlFileName.$dlFileExt -C $installPrefix
elif [[ $dlFileExt == "tar.bz2" ]]; then
    sudo tar -xjf $dlDir/$dlFileName.$dlFileExt -C $installPrefix
else
    errorMessage "File extension '$dlFileExt' not supported."
fi
	
# Was it successful?

if [ $? -eq 0 ]; then
    echo "Done."
else
   errorMessage "Inflating the archive failed with exit status of $?"
fi

# Install the package #########################################################

# Get dependencies first
echo "Installing dependencies..."
sudo aptitude install lib32readline5 -y
sudo aptitude install libsdl-image1.2 -y
sudo aptitude install expect -y
echo "Done."


# Create widgets directory for the Simulator at root
echo "Making $widgetDir directory..."
sudo $utilDir/mmkdir.sh "${widgetDir}"
echo "Done."

installPkg

if [ $? -eq 0 ]; then
    echo "Done."
else
   warningMessage "Install failed with exit status of $?"
   echo "Attempting to resolve dependencies..."
   exit 2
#   sudo aptitude -f install
#    if [ $? -eq 0 ]; then
#        echo "Done."
#        installPkg 
#    else
#        errorMessage "Could not update aptitude."
#    fi
fi

# Permissions

if [[ ! -n "`egrep -i ^$group: /etc/group`" ]]; then
	echo "Creating the $group group..."
	sudo groupadd $group
	echo "Done."
	echo
fi

echo "Changing group ownership of files..."
sudo chgrp -R $group $installPrefix/$installDirName
sudo chgrp -R $group /$widgetDir
echo "Done."
echo