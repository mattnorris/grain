#!

################################################################################
# Title:        up-hudson.sh
# Description:  Setup Hudson for continuos integration
# Author:       Matthew Norris
# Reference:    http://hudson-ci.org/
#
################################################################################

verbose=false

#utilDir="$HOME/scripts/util"
utilDir="util"

# Location to download source files
defDownloadDir=$HOME/sources
downloadDir=$defDownloadDir

# Location to install
defInstallPrefix=$HOME/dev/tools
installPrefix=$defInstallPrefix

# Linux group (used for permissions)
group=developers

# Download files
release="latest"    # or "supported", for a lower version
downloadSite="http://hudson-ci.org/$release"
archiveName="hudson.war"

# Friendly names
friendlyLinkName="hudson"

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
        errorMessage "$installPrefix is not a directory. Try '$(basename $0) --help' for help."
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
    echo "up-hudson - Install Hudson"
    echo "Usage: $(basename $0) [options...] [INSTALL DIRECTORY] [DOWNLOAD DIR]"
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
echo

# Download and install

echo $downloadDir 
echo "$downloadSite/$archiveName"

echo "Downloading $archiveName..."
if [[ ! -f $downloadDir/$archiveName ]]; then
	wget --directory-prefix=$downloadDir "$downloadSite/$archiveName"
	if [ $? -eq 0 ]; then
	    echo "Done."
	else
	   errorMessage "Download failed with exit status of $?"
	fi
else
    echo "$archiveName has already been downloaded."
fi
echo

echo "Installing Hudson to $installPrefix..."
#sudo unzip -q $downloadDir/$archiveName.zip -d $installPrefix
sudo cp $downloadDir/$archiveName $installPrefix

if [ $? -eq 0 ]; then
    echo "Done."
else
   errorMessage "Moving failed with exit status of $?"
fi

if [[ ! -n "$(egrep -i ^$group: /etc/group)" ]]; then
    echo "Creating the $group group..."
    sudo groupadd $group
    echo "Done."
    echo
fi

# Change permissions so members of the group can run its scripts

echo "Changing group ownership for $archiveName files..."
sudo chgrp $group $installPrefix/$archiveName
sudo chmod g+w $installPrefix/$archiveName
echo "Done."
echo

sudo ln -s $installPrefix/$archiveName /usr/local/$archiveName

echo "Hudson is installed."
