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

DOWNLOADS = os.path.join(os.environ['HOME'], 'dev/downloads')
util.mkdir(DOWNLOADS)
url = util.URL('http://www.web2py.com/examples/static/web2py_src.zip')
dl_file = os.path.join(DOWNLOADS, url.basename)

# If the file is not already present, download it. 
if not os.path.isfile(dl_file):
    print 'Downloading %s...' % url.basename 
    dl_file = url.download(dstdir=DOWNLOADS)
    print 'Done.\n'
    
# Check if the app dir in our project already has code in it. If so, 
# we need to upgrade.
PROJECT_SRC_DIR = os.path.join(util.get_virtualenv(), 'src')
PROJECT_APP_DIR = os.path.join(PROJECT_SRC_DIR, 'app')
CONTRIB_SRC_DIR = os.path.join(os.path.join(os.environ['HOME'], 'dev/modules/contrib'))
util.mkdir(PROJECT_SRC_DIR)
util.mkdir(PROJECT_APP_DIR)
util.mkdir(CONTRIB_SRC_DIR)

tmp_archive = tempfile.mkdtemp()
if os.listdir(PROJECT_APP_DIR):
    print 'Archiving existing applications...'
    applications = util.Archiver(os.path.join(PROJECT_APP_DIR, 
                                              'applications'))
    applications.archive(dstdir=tmp_archive, 
                         exclude=['admin', 'examples', 'welcome'])
    print 'Done.\n'
    print 'Removing old web2py framework...'
    shutil.rmtree(PROJECT_APP_DIR)
    print 'Done.\n'

# Extract the new framework.
print 'Installing new web2py framework...'     
web2py = util.Archiver(dl_file)
web2py.extract(dstdir=PROJECT_SRC_DIR, newrootname='app')
print 'Done.\n'

print 'Adding source to contrib folder on the PYTHONPATH...'
web2py.extract(dstdir=CONTRIB_SRC_DIR)
print 'Done.\n'

# Install the archived applications back into the framework.
if(os.listdir(tmp_archive)):
    print 'Installing archived applications...'
    archived_apps = util.Archiver(os.path.join(tmp_archive, 'applications.tgz'))
    archived_apps.extract(dstdir=PROJECT_APP_DIR)
    print 'Done.\n'