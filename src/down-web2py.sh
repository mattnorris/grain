#!

###############################################################################
# 
# Title:        down-web2py.sh
# Description:  Remove web2py, archiving any applications beforehand
# Author:       Matthew Norris
# Reference:    http://www.howtoforge.com/forums/showthread.php?t=96
#               http://bit.ly/tar-exclude
#
###############################################################################

function errorMessage() {
    echo -e "Error: $1"
    exit 1
}

INSTALL_DIR=$HOME/dev/source
UNINSTALL_DIR=$HOME/uninstall

# Check for 'uninstall' directory.  If one does not exist, make one.

if [ ! -d $UNINSTALL_DIR ]
  then
    echo "Making the $UNINSTALL_DIR directory.."
    mkdir $UNINSTALL_DIR
    echo "Done."
    echo
fi

# Archive any applications before removing

if [ -d $INSTALL_DIR/web2py/applications ]
  then 
  	cd $INSTALL_DIR/web2py
    ARCHIVE_FILE=$UNINSTALL_DIR/web2py.applications.$RANDOM.bak.tar.gz
    echo "Archiving existing applications to $ARCHIVE_FILE..."
    
    # For each 'exclude' argument, because 'cd' is used for the **local** 
    # "applications" directory, use the local "applications/[dir]" path rather 
    # than the **full** path to "applications". 
    tar -pczf $ARCHIVE_FILE applications --exclude "applications/admin" --exclude "applications/examples" --exclude "applications/welcome" --exclude "applications/__init__.py" --exclude "applications/__init__.pyc"
    
    if [ $? -eq 0 ]; then
        echo "Done."
        echo
	else
	   errorMessage "Moving failed with exit status of $?"
	fi
fi

# Remove web2py

echo "Removing web2py..."
rm -fr $INSTALL_DIR/web2py
echo "Done."
echo