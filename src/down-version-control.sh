#!/bin/bash

################################################################################
#
# Title:        down-version-control.sh
# Description:  Remove Git & Subversion
# Author:       Matthew Norris
#
################################################################################

sudo aptitude remove subversion -y
#sudo aptitude remove git-gui -y
sudo aptitude remove giggle -y
sudo aptitude remove git-core -y
