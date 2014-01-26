#!/bin/bash
# Title:        install-php.sh
# Description:  TODO: Write description of what this script does.   
# Author:       matthew
# Reference:    Removing phpmyadmin in case of errors - http://ubuntuforums.org/archive/index.php/t-881086.html
#

################################################################################
# Packages  
################################################################################

# Install PHP and all its packages needed to run from the command line. 
PKGS_PHP="php5 php5-curl php5-cli" 

# Install libraries to work with Apache and MySQL.
PKGS_PHP_LIB="libapache2-mod-auth-mysql php5-mysql"

# Install PHP admin for GUI administration. 
# **Requires manual intervention during its wizard. 
PKGS_PHPMYAMDIN="phpmyadmin"

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
    sudo aptitude install $PKGS_PHP -y
    sudo aptitude install $PKGS_PHP_LIB -y
    sudo aptitude install $PKGS_PHPMYAMDIN -y
    echo "Done."
}

# Removes packages installed and tears down any directories and files created. 
function removePackages() {
    echo "Removing `basename $0` tools & libraries..."  
    sudo aptitude remove $PKGS_PHPMYAMDIN -y
    sudo aptitude remove $PKGS_PHP_LIB -y	
    sudo aptitude remove $PKGS_PHP -y
    echo "Done."
    
    exit 0 # Exit so the default installation doesn't take place again. 
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

installPackages
