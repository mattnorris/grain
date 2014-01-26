#!

################################################################################
#
# Title:        down-hudson.sh
# Description:  Remove Hudson
# Author:       Matthew Norris
#
################################################################################

installPrefix=$HOME/dev/tools
UNINSTALL_DIR=$HOME/uninstall
archiveName="hudson.war"

# Friendly names
friendlyName="Hudson"
friendlyLinkName="hudson"

# Check for 'uninstall' directory.  If one does not exist, make one.
if [ ! -d $UNINSTALL_DIR ]
  then
    echo "Making the $UNINSTALL_DIR directory.."
    mkdir $UNINSTALL_DIR
    echo "Done."
    echo
fi

# Archive any preferences before removing.
if [ -d $HOME/.hudson ]
  then 
    cd $HOME
    ARCHIVE_FILE=$UNINSTALL_DIR/hudson.jobs.$RANDOM.bak.tar.gz
    
    echo "Archiving existing applications to $ARCHIVE_FILE..."
    tar -pczf $ARCHIVE_FILE .hudson
    
    if [ $? -eq 0 ]; then
        echo "Done."
        echo
    else
       errorMessage "Moving failed with exit status of $?"
    fi
fi

# Remove hudson
echo "Removing $friendlyName..."
sudo rm -fr $HOME/.hudson
sudo rm /usr/local/$archiveName
sudo rm $installPrefix/$archiveName
echo "Done."