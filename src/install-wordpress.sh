#!/bin/bash
# Title:        install-wordpress.sh
# Description:  Downloads and installs WordPress. 
# Required:     MySQL, PHP, Apache
# Author:       matthew
# Reference:    http://wordpress.org/download/release-archive/
#               http://premium.wpmudev.org/project/qa-wordpress-questions-and-answers-plugin/installation/
#
#               http://www.squidoo.com/wordpress-not-found-error-fix
#

DOWNLOADS=$HOME/dev/downloads

WP_VERSION=3.1.3 # works with Q&A plugin
WP_PKG="wordpress-$WP_VERSION.zip"
WP_SITE="http://wordpress.org/$WP_PKG"

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
    # TODO: Write a setup function. 
    echo "Installing `basename $0` tools & libraries..."
    
    # Get latest Wordpress. 
    #wget http://wordpress.org/latest.tar.gz
    #tar -xzvf latest.tar.gz 
    
    cd $DOWNLOADS
    # Get the zip file if it isn't yet downloaded. 
    if [ ! -e $WP_PKG ]; then
    	wget $WP_SITE -O $WP_PKG
    fi

    echo "Done."
    
    exit 0
}

# Removes packages installed and tears down any directories and files created. 
function removePackages() {
    # TODO: Write a tear down function.
    #echo "Removing `basename $0` tools & libraries..." 
    echo "Function not implemented! Nothing was done!"
    #echo "Done." 
    
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
        -d|--dst)
            shift 1
            DST_DIR="$1"
            shift 1
            ;;
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

# TODO: Write the main script here.

echo "Executing `basename $0`..."
installPackages
echo "Done."
 
