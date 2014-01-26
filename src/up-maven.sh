#!

################################################################################
#
# Title:        up-dlFileName.sh
# Description:  Setup Grails for rapid Java development
# Author:       Matthew Norris
# Reference:    http://www.grails.org/Installation
#               http://bit.ly/maven2
#
################################################################################

verbose=false

#utilDir="$HOME/scripts/util"
utilDir="util"

# Location to download source files
defDownloadDir=$HOME/dev/downloads
dlDir=$defDownloadDir

# Location to install
defInstallPrefix=/opt/dev/tools
installPrefix=$defInstallPrefix

# Linux group (used for permissions)
group=developers

# Download files

dlPrefix="http://mirror.candidhosting.com/pub/apache/maven/binaries/"
dlFileName="apache-maven-2.2.1-bin"
dlFileExt="tar.gz"

# Default install directory name
installDirName="apache-maven-2.2.1"

# Friendly name for messages
friendlyName="Maven 2"
friendlyLinkName="maven"

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
    echo "up-maven - Install Maven 2.2.1"
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

sudo $utilDir/mmkdir.sh $dlDir
echo

# Download Grails and install it.

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
    sudo tar -zxvf $dlDir/$dlFileName.$dlFileExt -C $installPrefix 
else
    errorMessage "File extension '$dlFileExt' not supported."
fi
	
# Was it successful?

if [ $? -eq 0 ]; then
    echo "Done."
else
   errorMessage "Inflating the archive failed with exit status of $?"
fi

# Add a symlink to /usr/local/bin so that we can use mvn from the command line

echo "Linking $friendlyName to /usr/local/bin..."
sudo ln -s $installPrefix/$installDirName/bin/mvn /usr/local/bin
echo "Done."

echo "Linking $installPrefix/$installDirName to $installPrefix/$friendlyLinkName..."
sudo ln -s $installPrefix/$installDirName $installPrefix/$friendlyLinkName
echo "Done."

echo
echo "$friendlyName installed."
