#!

################################################################################
#
# Title:        up-bash.sh
# Description:  Setup personal bash to be attractive and informative
# Author:       Matthew Norris
# Reference:    http://bit.ly/slicehost-ubuntu-setup
#
################################################################################

# Make the terminal more attractive and informative by adding a few lines to 
# the .bashrc file.

# Check that the user has given an arg and that is a valid file.
if [ -n "$1" ] && [ -f $1 ]
  then

    bashFile="$HOME/.bashrc"
    bashBackup="$bashFile.bak"
    customLines="$1"
    bashTemp="/tmp/$(basename $0).$RANDOM"

    echo "Backing up your current .bashrc..."

    cp $bashFile $bashBackup

    echo "Adding your custom lines to .bashrc..."

    cat $bashFile $customLines > $bashTemp
    cp $bashTemp $bashFile
    rm $bashTemp

    echo "Changes saved.  Activating changes..."

    # Activate the changes made by this script to bash
    cd $HOME
    source $bashFile

    echo "Changes activated."
else
  echo "'$1' does not exist.  Please specify another file."
  exit 1
fi
