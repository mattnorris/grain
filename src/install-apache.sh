#!/bin/bash
# Title:        install-apache.sh
# Description:  Installs Apache
# Author:       Matthew Norris
# Reference:    https://help.ubuntu.com/community/ApacheMySQLPHP#Virtual%20Hosts
#               http://www.grymoire.com/Unix/Sed.html
#               tee command - http://bit.ly/bfK1wb
#

################################################################################
# File & directory locations  
################################################################################

SITES_CONFIG_DIR=/etc/apache2/sites-available

# Default 
DEF_SITE=default
DEF_SITES_DIR="/var/www"

DEF_LOGS_DIR=/var/log/apache2
DEF_ERROR_LOG=errors.log
DEF_ACCESS_LOG=access.log

# New 
NEW_SITES_DIR="$HOME/dev/www"
NEW_SITE=development
NEW_LOGS_DIR=$HOME/dev/log/apache2

################################################################################
# Packages  
################################################################################

PKGS_APACHE="apache2"

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
    sudo aptitude install $PKGS_APACHE -y
    echo "Done."
    echo 
    echo "Creating a new site in $NEW_SITES_DIR"
    mkdir -p $NEW_SITES_DIR
    mkdir -p $NEW_LOGS_DIR
    
    # Create a new site, using the default as a template.
    # 
    # NOTE: Using a > won't redirect the output properly because sudo loses its 
    # permission by the time it gets to the >. Instead, pipe the output to 
    # tee instead. See http://bit.ly/bfK1wb for more details. 
    cd $SITES_CONFIG_DIR
    sudo sed -e "s:$DEF_SITES_DIR:$NEW_SITES_DIR:g" -e "s:$DEF_LOGS_DIR:$NEW_LOGS_DIR:g" < $DEF_SITE | sudo tee $NEW_SITE
    echo "Done."
    echo
    
    # Deactivate the old site & activate the new one. 
    echo "Activating new site, '$NEW_SITE'..."
    sudo a2dissite $DEF_SITE && sudo a2ensite $NEW_SITE
    sudo /etc/init.d/apache2 restart
    echo "Done."
    echo
    echo "Place anything you want served by localhost in $NEW_SITES_DIR"
    echo
}

# Removes packages installed and tears down any directories and files created. 
function removePackages() {
    echo "Removing `basename $0` tools & libraries..."
    sudo a2dissite $NEW_SITE && sudo a2ensite $DEF_SITE 
    sudo /etc/init.d/apache2 stop
    sudo rm "$SITES_CONFIG_DIR/$NEW_SITE"
    sudo aptitude remove $PKGS_APACHE -y
    echo "Done."
    
    exit 0 
}

################################################################################
# Command line processing
################################################################################

# Parse the command line arguments. 
while [ "$#" -gt "0" ]; do
    case "$1" in
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

