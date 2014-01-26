#!/bin/bash
# Title:        install-python.sh
# Description:  Installs or removes Python 2.5 & 2.6 on Ubuntu 10.04+. Includes 
#               dev & doc utilities, virtualenv, and its wrapper.  
# Author:       matthew 
# Reference:    http://jordilin.wordpress.com/2010/05/02/python2-4-python2-5-and-ubuntu-10-04-lucid-lynx/
#               http://ubuntuforums.org/showpost.php?s=bb4c9d3d2847f287d29fee7b64f3c25b&p=9231244&postcount=6
#

################################################################################
# Default locations  
################################################################################

DOWNLOADS=$HOME/dev/downloads

################################################################################
# Packages  
################################################################################

PKGS_PY="python-lxml python2.5 python2.5-dev python2.6-dev python-docutils"

# These are the latest setuptools. Ubuntu repositories do not contain the latest. 
TOOLS_EGG_25="setuptools-0.6c11-py2.5.egg"
TOOLS_EGG_26="setuptools-0.6c11-py2.6.egg"
TOOLS_SITE_25="http://pypi.python.org/packages/2.5/s/setuptools/$TOOLS_EGG_25"
TOOLS_SITE_26="http://pypi.python.org/packages/2.6/s/setuptools/$TOOLS_EGG_26"

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
    echo "Usage: `basename $0` [options...]"
    echo "Options:"
    echo "  -h/--help     Prints this message"
    
    # TODO: Add help messages for your options here. 
    
    exit 1
}

################################################################################
# Installation functions 
################################################################################

# Installs packages and sets up directories and files. 
function installPackages() {
    echo "Installing `basename $0` tools & libraries..."
    sudo aptitude install $PKGS_PY -y
    echo "Done."
    
    echo "Installing setuptools..."
    mkdir -p $DOWNLOADS
    cd $DOWNLOADS
    if [ ! -e $TOOLS_EGG_25 ]; then
    	wget $TOOLS_SITE_25 -O $TOOLS_EGG_25
    fi
    if [ ! -e $TOOLS_EGG_26 ]; then
        wget $TOOLS_SITE_26 -O $TOOLS_EGG_26
    fi
    sudo sh $TOOLS_EGG_25
    sudo sh $TOOLS_EGG_26
    echo "Done."
    
    echo "Installing virtualenv and its wrapper..."
    sudo easy_install virtualenv
    sudo easy_install virtualenvwrapper
    	
    # Symlink virtualenv so it can be found at the global level. 
    # http://floppix.ccai.com/scripts1.html
    #cd /usr/bin
    #sudo ln -s /usr/local/bin/virtualenv virtualenv
    
    echo "Done."
    
    exit 0
}

# Removes packages installed and tears down any directories and files created. 
function removePackages() {
    echo "Removing virtualenv and wrapper..."
    #sudo rm /usr/bin/virtualenv
    sudo easy_install -m virtualenvwrapper
    sudo easy_install -m virtualenv
    echo "Done."
    
    echo "Cannot remove setuptools."
    echo "See http://www.eby-sarna.com/pipermail/peak/2006-February/002450.html"
    
    echo "Removing `basename $0` tools & libraries..." 
    sudo aptitude remove $PKGS_PY -y
    echo "Done." 
    
    exit 0
}

################################################################################
# Command line processing
################################################################################

# Parse the command line arguments. 
while [ "$#" -gt "0" ]; do
    case "$1" in
     
    #   TODO:    Create some script options. 
    #   EXAMPLE: Uncomment below to assign a 'destination directory', DST_DIR, 
    #            to the arg given after a '-d' or '--dst' on the command line.
    # 
    #   -d|--dst)
    #       shift 1 # eat the '-d' or '--dst'
    #       DST_DIR="$1" # assign the next arg as this variable 
    #       shift 1 # eat the arg you just assigned
    #       ;;
        -r|--remove)
            shift 1
            removePackages
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
echo "Ubuntu 10.04+ repositories do not contain python2.5 by default."
echo "Add a repository and update the system."
sudo add-apt-repository ppa:fkrull/deadsnakes
sudo apt-get update
sudo apt-get update # run twice to get rid of any conflicts

installPackages
