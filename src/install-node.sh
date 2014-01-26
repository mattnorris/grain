#!/bin/bash
# Title:        install-node.sh
# Description:  Installs node.js.   
# Author:       wraithmonster
# Reference:    https://github.com/joyent/node/wiki/Installation 
#               Web framework - http://expressjs.com/
#               Node Pkg Manager - https://github.com/isaacs/npm
#

################################################################################
# Default locations  
################################################################################

DST_DIR=$HOME/dev/tools

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
    echo "  -r/--remove   Removes Node and Node Package Manager"
    
    exit 1
}

################################################################################
# Installation functions 
################################################################################

# Installation script generated at http://apptob.org (link broken as of 2/17/2012).
function apptobScript() {
	####################################
	#
	# Author: Ruslan Khissamov, email: rrkhissamov@gmail.com
	#
	####################################
	
	# Update System
	echo 'System Update'
	sudo apt-get update # sudo added
	echo 'Update completed'
	sudo apt-get install git-core curl python-software-properties # sudo added 
	
	# Install Node.js
	echo 'Install Node.js'
	# TODO: Check if repo is already installed before adding. 
	sudo add-apt-repository ppa:chris-lea/node.js # sudo added
	sudo apt-get update # sudo added
	sudo apt-get install nodejs nodejs-dev -y # sudo added, -y added
	echo 'Node.js install completed'
	
	# Install Node Package Manager
	echo 'Install Node Package Manager'
	curl http://npmjs.org/install.sh | sudo sh
	echo 'NPM install completed'
}

# Installs packages and sets up directories and files. 
function installPackages() { 
    echo "Installing `basename $0` tools & libraries..."
    
    sudo aptitude install libssl-dev -y
    apptobScript
    
#    mkdir -p $DST_DIR
#    cd $DST_DIR
#    npm install express
    
    echo "Done."
    
    exit 0
}

# Removes packages installed and tears down any directories and files created. 
function removePackages() {
    
    echo "Removing `basename $0` tools & libraries..." 
    
#    npm remove express
    
    # Reverse the apptob script. 
    sudo npm uninstall npm -g
    sudo apt-get remove nodejs nodejs-dev -y
    
    # TODO: Can we remove a repository? 
    echo
    echo "Not removing chris-lea repository." 
    echo
    echo "Not removing the libssl-dev library (a dependency required for Node)."
    echo "Other programs depend on this."
    echo 
    echo "Done." 
    
    exit 0
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

echo "Executing `basename $0`..."
installPackages
echo "Done."

