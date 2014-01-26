"""
Installs or upgrades the web2py framework in a virtual environment. 
"""
import os
import sys
import tempfile
import shutil

sys.path.append(os.path.join(os.environ['HOME'], 'dev/modules'))
from poprop import util

__author__ = "Matthew Norris"
__copyright__ = "Copyright 2011, Matthew Norris"

if not util.in_virtualenv():
    sys.exit('Script not running in a virtual environment. Exiting.')

SRC_DIR_NAME = 'src'
DOWNLOADS = os.path.join(os.environ['HOME'], 'dev/downloads')
util.mkdir(DOWNLOADS)
url = util.URL('http://www.tipfy.org/tipfy.zip') #EDIT
dl_file = os.path.join(DOWNLOADS, url.basename)

# If the file is not already present, download it. 
if not os.path.isfile(dl_file):
    print 'Downloading %s...' % url.basename 
    dl_file = url.download(dstdir=DOWNLOADS)
    print 'Done.\n'
    
# Check if the app dir in our project already has code in it. If so, 
# we need to upgrade.
PROJECT_SRC_DIR = os.path.join(util.get_virtualenv(), 'project')
PROJECT_APP_DIR = os.path.join(PROJECT_SRC_DIR, SRC_DIR_NAME)
#CONTRIB_SRC_DIR = os.path.join(os.path.join(os.environ['HOME'], 'dev/modules/contrib')) # EDIT
util.mkdir(PROJECT_SRC_DIR)
util.mkdir(PROJECT_APP_DIR)
#util.mkdir(CONTRIB_SRC_DIR) # EDIT

# Extract the new framework.
print 'Installing...'     
web2py = util.Archiver(dl_file)
web2py.extract(dstdir=PROJECT_SRC_DIR, newrootname=SRC_DIR_NAME)
print 'Done.\n'
