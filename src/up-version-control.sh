#!/bin/bash

################################################################################
#
# Title:        up-version-control.sh
# Description:  Install Git & Subversion
# Author:       Matthew Norris
#
################################################################################

utilDir="util"

# Install Git (also installs libdigest-sha1-perl & liberror-perl{a}) 

sudo aptitude install git-core -y
# sudo aptitude install git-gui -y
sudo aptitude install giggle -y

# Make an SSH directory for git commits 
$utilDir/mmkdir.sh -v "$HOME/.ssh"
echo 

# Install Subversion

sudo aptitude install subversion -y
