#!

################################################################################
#
# Title:        up-web2py.sh
# Description:  Install web2py, a Python web framework
# Author:       Matthew Norris
# Reference:    http://www.web2py.com
#               http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_02.html
#               http://mdp.cti.depaul.edu/AlterEgo/default/show/12
#
################################################################################

SOURCES=$HOME/sources
INSTALL_DIR=$HOME/dev/source

WEB2PY_SITE=http://www.web2py.com/examples/static
WEB2PY=web2py_src.zip

# Check for 'sources' directory.  If one does not exist, make one.

if [ ! -d $SOURCES ]
  then
    echo "Making the $SOURCES directory.."
    mkdir $SOURCES
    echo "Done."
    echo
fi

# Download and install web2py.

echo "Downloading $WEB2PY..."
cd $SOURCES
if [ ! -f $WEB2PY ] 
  then 
    wget $WEB2PY_SITE/$WEB2PY
    echo "Done."
  else
    echo "$WEB2PY has already been downloaded."
fi
echo

# Check for previous installation and the proper directory.

if [ -n "$1" ] && [ -d $1 ]; then 
	INSTALL_DIR="$1" 
else
    echo "$1 is not a directory. Using $INSTALL_DIR instead."
fi

if [ -d $INSTALL_DIR/web2py ]
  then
    echo "web2py is already installed. If you are upgrading:"
    echo "  1. Run the accompanying 'down-web2py.sh' script first."
    echo "     This will archive your applications for reinstallation."
    echo "  2. Run this script again."
    echo "  3. Extract your archived applications into the new web2py/applcations folder."
    echo "  4. Done! Run web2py normally."
    exit 1

# Create the install directory if it doesn't exist.

elif [ ! -d $INSTALL_DIR ]
  then
    echo "Making the $INSTALL_DIR directory.."
    mkdir $INSTALL_DIR
    echo "Done."
    echo 
fi

# Install web2py by unzipping.

echo "Unzipping $WEB2PY..."
unzip -q $SOURCES/$WEB2PY -d $INSTALL_DIR
echo "Done."
echo
echo "web2py is now installed in $INSTALL_DIR/web2py"
