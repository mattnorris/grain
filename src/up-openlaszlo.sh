#!

######### INCOMPLETE #########

################################################################################
# Title:        up-openlaszlo
# Description:  Setup OpenLaszlo
# Author:       Matthew Norris
# Reference:    http://www.openlaszlo.com/taxonomy/term/8
#               http://www.openlaszlo.org/lps4.5/docs/installation/install-instructions.html
#
################################################################################

verbose=false

#utilDir="$HOME/scripts/util"
utilDir="../util"

# Location to download source files
defDownloadDir=$HOME/sources
downloadDir=$defDownloadDir

# Location to install
defInstallPrefix="/opt/dev/sdks"
installPrefix=$defInstallPrefix

# Linux group (used for permissions)
group="developers"

# Default install directory & app names
laszloVersion="4.6.1"
installDirName="lps-$laszloVersion"
archiveFileName="openlaszlo-$laszloVersion-unix.tar.gz"

# Friendly names
sdkFriendlyName="OpenLaszlo"

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
    downloadDir=$(expr "$2" : '[[:space:]]*\(.*\)[[:space:]]*$' | sed -e 's/\\/$//g')
    
    # Check for null and whitespace
    if [[ -z "$installPrefix" ]] || [[ ! -n "$installPrefix" ]]; then
        warningMessage "No INSTALL DIRECTORY specified. Using default: $defInstallPrefix"
        installPrefix=$defInstallPrefix
    fi
    
    if [[ -z "$downloadDir" ]] || [[ ! -n "$downloadDir" ]]; then
        warningMessage "No DOWNLOAD DIRECTORY specified. Using default: $defDownloadDir"
        downloadDir=$defDownloadDir
    fi
    
    # Do the specified directories exist?
    if [[ ! -d $installPrefix ]]; then 
        errorMessage "$installPrefix is not a directory. Try '$(basename $0) --help' for help."
    fi
    
    if [[ ! -d $downloadDir ]]; then 
        errorMessage "$downloadDir is not a directory. Try '$(basename $0) --help' for help."
    fi
}

function checkParamStr() {
    # If there are no parameters, throw error
    if [[ "${#1}" -eq "0" ]]; then
        errorMessage "No parameters. Try '$(basename $0) --help' for help."
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
    echo "up-openlaszlo - Install $sdkFriendlyName"
    echo "Usage: $(basename $0) [options...] [-l language] [DIRECTORY] [DOWNLOAD DIR]"
    echo "Options:"
    echo "  -v/--verbose   Not yet implemented"
    echo "  -h/--help      Output this message"
    
    exit 1
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
        -l|--language)
            checkLang "$2"
            shift 2
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

if [[ ! -f "$utilDir/mmkdir.sh" ]]; then
    errorMessage "'mmkdir.sh' not found in '$utilDir'. Please specify the proper directory."
fi

$utilDir/mmkdir.sh $downloadDir
$utilDir/mmkdir.sh $installPrefix
echo

if [[ ! -f $downloadDir/$archiveFileName ]]; then
    errorMessage "$archiveFileName does not exist."
fi

echo "Installing $sdkFriendlyName to $installPrefix..."
sudo tar -C $installPrefix -zxvf $downloadDir/$archiveFileName
echo "Done."
echo
echo "Granting permissions..."
sudo chmod 755 $installPrefix/$installDirName/Server/$installDirName/WEB-INF/bin/*
sudo chmod 775 $installPrefix/$installDirName/Server/tomcat-5.0.24/logs
sudo chmod 775 $installPrefix/$installDirName/Server/tomcat-5.0.24/conf
echo "Done."
echo 

################################################################################
# Permissions & symlinks
################################################################################

if [[ ! -n "$(egrep -i ^$group: /etc/group)" ]]; then
	echo "Creating the $group group..."
	sudo groupadd $group
	echo "Done."
	echo
fi

# Change permissions so members of the group can run its scripts  

echo "Changing group ownership for $sdkFriendlyName files..."
sudo chgrp -R $group $installPrefix/$installDirName
echo "Done."
echo

# Add a symlink to /usr/local

echo "Linking $sdkFriendlyName to /usr/local/..."
sudo ln -s $installPrefix/$installDirName /usr/local/$installDirName
echo "Done."
echo
echo "$sdkFriendlyName installed."
