"""
Installs or removes Selenium Remote Control. 

@see: http://seleniumhq.org
"""
import os
import sys
import shutil

sys.path.append(os.path.join(os.environ['HOME'], 'dev/modules'))
from poprop import util

VERSION = "1.0.3" # Change for newer versions

INSTALL_NAME = 'selenium-remote-control-%s' % VERSION 
FILE = "http://selenium.googlecode.com/files/%s.zip" % INSTALL_NAME
DOWNLOAD_DIR = os.path.join(os.environ['HOME'], 'dev/downloads')
INSTALL_DIR = os.path.join(os.environ['HOME'], 'dev/tools')

def install():
    """
    Downloads (if necessary) and installs Selenium.
    """
    util.mkdir(DOWNLOAD_DIR)
    util.mkdir(INSTALL_DIR)

    url = util.URL(FILE)
    dl_file = os.path.join(DOWNLOAD_DIR, url.basename)
    if not os.path.isfile(dl_file):
        print 'Downloading %s...' % INSTALL_NAME
        url.download(dstdir=DOWNLOAD_DIR)
        print 'Done.\n'

    print 'Installing %s...' % INSTALL_NAME
    arc = util.Archiver(dl_file)
    arc.extract(dstdir=INSTALL_DIR, newrootname=INSTALL_NAME)
    print 'Done.\n'
    
#    print 'Type Unable to access jarfile /opt/dev/tools/selenium-remote-control-1.0.1/selenium-server-1.0.1/selenium-server.jar'
    print 'Type \'%s/%s/selenium-server-%s/selenium-server.jar\' to use.' % \
        (INSTALL_DIR, INSTALL_NAME, VERSION)

    
def remove():
    """
    Removes Selenium. 
    """
    print 'Removing %s...' % INSTALL_NAME
    shutil.rmtree(os.path.join(INSTALL_DIR, INSTALL_NAME))
    print 'Done.\n'

def exit():
    """
    Exits script with appropriate message. 
    """
    print 'USAGE: python manage_selenium.py [install|remove]'
    sys.exit()

# Run the script. 
try:
    if sys.argv[1] == 'install':
        install()
    elif sys.argv[1] == 'remove':
        remove()
    else:
        exit()
except IndexError:
    exit()