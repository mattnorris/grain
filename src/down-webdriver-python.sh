#!

################################################################################
# 
# Title:        down-webdriver-python.sh
# Description:  Remove WebDriver for use with Python
# Author:       Matthew Norris
# Reference:    
# 
################################################################################

# TODO: Not working correctly!

INSTALL_DIR_NAME="webdriver" # name not accurate - 0.7
FRIENDLY_NAME="WebDriver"

echo "Removing $FRIENDLY_NAME..."

sudo rm -fr /usr/lib/python2.5/site-packages/$INSTALL_DIR_NAME

sudo rm -fr /usr/lib/python2.6/dist-packages/$INSTALL_DIR_NAME
sudo rm -fr /usr/lib/python2.6/site-packages/$INSTALL_DIR_NAME

#sudo rm /usr/bin/django-admin.py

echo "Done."