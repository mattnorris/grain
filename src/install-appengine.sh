#!/bin/bash
# Title:        install-appengine.sh
# Description:  Installs Google App Engine to the user's local dev setup. 
# Author:       matthew
# Reference:    Not used, but helpful: http://stackoverflow.com/questions/229551/string-contains-in-bash/229606#229606
#

################################################################################
# Locations 
################################################################################

DEF_VERSION=1.5.0
SYMLINK=google_appengine

# Local directories
DOWNLOADS=$HOME/dev/downloads
SDKS=$HOME/dev/sdks

# Google's remote directory and files 
GOOGLE_SITE_DIR=http://googleappengine.googlecode.com/files

PDIRPREFIX="google_appengine_"
JDIRPREFIX="appengine-java-sdk-"

################################################################################
# Helper functions 
################################################################################

# Prints the given error message and exits.
function errorMessage() {
    echo -e "Error: $1. Type '`basename $0` -h' for usage and options."
    exit 1
}

# Prints the given warning message and exits.
function warningMessage() {
    echo -e "Warning: $1."
    exit 2
}

# Prints this script's usage and exists. 
function outputUsage() {
    echo "Usage: `basename $0` LANGUAGE [options...]"
    echo "Options:"
    echo "  -h/--help       Prints this message"
    echo "  -r/--remove     Removes the given language's packages"
    
    # TODO: Add help messages for your options here. 
    
    exit 1
}

################################################################################
# Installation functions 
################################################################################

# Installs packages and sets up directories and files. 
function installPackages() { 
    echo "Installing $1 $2..."
	
	# If we've been given a version, use it. 
	if [ ! -n "$2" ]; then 
		VERSION=$DEF_VERSION
	fi
	
	PDIR="$PDIRPREFIX$VERSION"
	PPKG="$PDIR.zip"
	JDIR="$JDIRPREFIX$VERSION"
	JPKG="$JDIR.zip"
    
    if [ "$1" = "python" ]; then
    	PKG=$PPKG
    elif [ "$1" = "java" ]; then
        PKG=$JPKG
    fi 
    
    # If the package hasn't been downloaded, download it.
    cd $DOWNLOADS
    if [ ! -e $PKG ]; then
    	wget $GOOGLE_SITE_DIR/$PKG
    fi
    
    unzip $PKG -d $SDKS
    
    if [ $1 = "python" ]; then 
    	cd $SDKS
    	mv $SYMLINK $PDIR 
    	ln -s $PDIR $SYMLINK
    	
    	# TODO: In case of path errors, symlink 'django' to 'django_0_96' or 
    	# 'django_1_2'. This is how it's referred to now in App Engine. 
    fi
    
    echo "Done."
    exit 0
}

# Removes packages installed and tears down any directories and files created. 
function removePackages() {
	# TODO: Check that $1 is not empty string.
	
	if [ ! -n "$1" ]; then
		errorMessage $1
	fi
	
    # If we've been given a version, use it. 
    if [ ! -n "$2" ]; then 
        VERSION=$DEF_VERSION
    fi
	
    echo "Removing `basename $0` tools & libraries..." 
    
    if [ "$1" = "python" ]; then
        export PKG="$PDIRPREFIX$VERSION"
    elif [ "$1" = "java" ]; then
        export PKG="$JDIRPREFIX$VERSION"
    fi 
    
    #echo $PKG

    # Remove directory. 
    cd $SDKS
    rm -fr $PKG

    # Remove symlink. 
    if [ "$1" = "python" ]; then
        rm $SYMLINK
    fi

    echo "Done." 
    
    exit 0
}

################################################################################
# Command line processing
################################################################################

# Check for a language option, which is required. 
if [ $# -lt 1 ]; then
    errorMessage $#
fi

# Parse the command line arguments. 
while [ "$#" -gt "0" ]; do
	# Convert to lowercase. 
	ARG=`echo "$1" | tr '[A-Z]' '[a-z]'`
    case $ARG in
     
    #   TODO:    Create some script options. 
    #   EXAMPLE: Uncomment below to assign a 'destination directory', DST_DIR, 
    #            to the arg given after a '-d' or '--dst' on the command line.
    # 
    #   -d|--dst)
    #       shift 1 # eat the '-d' or '--dst'
    #       DST_DIR="$1" # assign the next arg as this variable 
    #       shift 1 # eat the arg you just assigned
    #       ;;
        java|python)
            GAE_LANG=$ARG
            shift 1
            ;;
        -v|--version)
            shift 1
            VERSION="$1"
            shift 1
            ;;
        -r|--remove)
            shift 1
            removePackages $GAE_LANG
            ;;
        -h|--help)
            outputUsage
            ;;
        -*|--*)
            errorMessage "Unknown option $1"
            ;;
        *)
            errorMessage "Unknown parameter $1"
            ;;
    esac
done

################################################################################
# Main
################################################################################

echo "Executing `basename $0`..."

# TODO: Always install afterwards because this is hit each time. 
installPackages $GAE_LANG $VERSION

echo "Done."
