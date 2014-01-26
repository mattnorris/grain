#!/bin/bash
# Title:        install-mysql.sh
# Description:  Installs MySQL, tools, and drivers for working with PHP, Ruby, 
#               and more.    
# Author:       Matt Norris
# Reference:    Slicehost - http://bit.ly/cLQzmW
#               dpkg - http://bit.ly/dvX9un
#               dpkg dependency errors - http://bit.ly/b2L2Ni
#               dpkg dependency error detection explained - http://bit.ly/bf2ChF
#

################################################################################
# Default locations  
################################################################################

DOWNLOADS=$HOME/dev/downloads

################################################################################
# Packages  
################################################################################

# MySQL installer is graphical, so we'll have to babysit it. 
PKGS_MYSQL="mysql-server mysql-client libmysqlclient15-dev"

# Ruby libraries for operating with MySQL. 
PKGS_RUBYLIB="libmysql-ruby1.8"

# A graphical tool for viewing databases
PKGS_EMMA="emma" 

# MySQL Workbench
PKG_MSWB="mysql-workbench-gpl-5.2.29-1ubu1004-amd64.deb"
PKG_MSWB_SITE="http://dev.mysql.com/get/Downloads/MySQLGUITools/$PKG_MSWB/from/http://mysql.mirrors.hoobly.com/"

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
    sudo aptitude install $PKGS_MYSQL -y
    sudo aptitude install $PKGS_RUBYLIB -y
    
    cd $DOWNLOADS
    # Get the Workbench package if it isn't yet downloaded. 
    if [ ! -e $PKG_MSWB ]; then
        wget $PKG_MSWB_SITE -O $PKG_MSWB
    fi
    
    # Install Workbench, directing any dependency errors into stdout. 
    sudo dpkg -i $PKG_MSWB 2>&1
    	
    # If there were errors, get the generated list of dependencies and install. 
    if [ $? -gt 0 ]; then
    	sudo apt-get -f --force-yes --yes install 2>&1
    	sudo dpkg -i $PKG_MSWB 2>&1
    fi
    
    echo "Done."
}

# Removes packages installed and tears down any directories and files created. 
function removePackages() {
	echo "Removing `basename $0` tools & libraries..."
	sudo dpkg -r mysql-workbench-gpl
    sudo aptitude remove $PKGS_RUBYLIB -y
    sudo aptitude remove $PKGS_MYSQL -y
    echo "Done."
    
    exit 0 # Exit so the default installation doesn't take place again. 
}

################################################################################
# Command line processing
################################################################################

# Parse the command line arguments. 
while [ "$#" -gt "0" ]; do
    case "$1" in
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
