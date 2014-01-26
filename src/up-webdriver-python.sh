#!

################################################################################
# 
# Title:        up-webdriver-python.sh
# Description:  Setup WebDriver/Selenium for use with Python
# Author:       Matthew Norris
# Reference:    http://code.google.com/p/selenium/wiki/PythonBindings
# 
################################################################################

SOURCES=$HOME/sources
SDKS=/opt/dev/sdks
TOOLS=/opt/dev/tools

SVN_TRUNK=http://selenium.googlecode.com/svn/trunk/
ROOT_DIR=selenium-read-only

FRIENDLY_NAME="WebDriver"

function errorMessage() {
    echo -e "Error: $1"
    exit 1
}

# Check for 'sources' directory.  If one does not exist, make one.

if [ ! -d $SOURCES ]; then
    echo "Making the $SOURCES directory.."
    mkdir $SOURCES
fi

cd $SOURCES

if [ -d $SOURCES/$ROOT_DIR ]; then
    echo "$ROOT_DIR exists. Using local copy."
else
    echo "Checking out $FRIENDLY_NAME from subversion..."
    
    svn checkout $SVN_TRUNK $ROOT_DIR
    
    if [ $? -eq 0 ]; then
        echo "Done."
    else
       errorMessage "Checkout failed with exit status of $?"
    fi    
fi

cd $ROOT_DIR

echo "Installing $FRIENDLY_NAME for python2.5 and python2.6..."
sudo python2.6 setup.py install
sudo python2.5 setup.py install
echo "Done."