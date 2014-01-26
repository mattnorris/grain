#!/bin/bash
# Title:        install-postfix.sh
# Description:  Installs postfix mail server and configures it to use 
#               Optimum Online as a relay (required by the ISP). 
# Author:       matthew
# Reference:    TODO: Record any references, like URLs, here. 
#

CONFIG_FILE="/etc/postfix/main.cf"
RELAYHOST="mail.optonline.net"

BACKUP_DIR="$HOME/dev/backup"

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
    sudo aptitude install postfix -y
    echo "Done."
    echo
    echo "Backing up current configuration to $CONFIG_FILE.bak..."
    sudo cp $CONFIG_FILE "$BACKUP_DIR/main.cf.bak"
    echo "Done."
    echo
    echo "Configuring mail server..."
    sudo sed -e "s:relayhost = :relayhost = $RELAYHOST:" < $CONFIG_FILE | sudo tee $CONFIG_FILE
    echo "Done."
    echo "Reloading mail server..."
    sudo /etc/init.d/postfix reload
    echo "Done."
    echo
    
    exit 0
}

# Removes packages installed and tears down any directories and files created. 
function removePackages() {
	#echo "Reverting configuration to saved $CONFIG_FILE.bak..."
    #sudo  cp "$BACKUP_DIR/main.cf.bak" $CONFIG_FILE
    #echo "Done."
	#echo
    echo "Removing `basename $0` tools & libraries..." 
    sudo aptitude purge postfix -y # 'purge' removes all config files too
    echo "Done."
    echo
    
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

installPackages
