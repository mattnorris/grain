"""
Installs Pyccuracy in a virtual environment. 
"""
import os
import sys
import shutil

sys.path.append(os.path.join(os.environ['HOME'], 'dev/modules'))
from poprop import util

__author__ = "Matthew Norris" 

################################################################################
#
# Title:         install_pyccuracy.py
# Author:        Matthew Norris
# Description:   Setup Pyccuracy on a virtual environment.
# Dependencies:  setuptools, virtualenv
# References:    http://www.pyccuracy.org/getting_started_1.html
#                http://bit.ly/python-virtualenv
#                http://docs.python.org/library/os.path.html
#
################################################################################

if not util.in_virtualenv():
    sys.exit('Script not running in a virtual environment. Exiting.')

REL_CONTRIB_PATH = 'modules/contrib'    
CONTRIB_DIR = os.path.join(util.get_virtualenv(), REL_CONTRIB_PATH)
DOWNLOADS = os.path.join(os.environ['HOME'], 'dev/downloads')
INSTALL_DIR_NAME = 'pyccuracy'

# Install dependencies.
os.system('easy_install lxml')    
os.system('easy_install selenium')
os.system('easy_install pyoc')

util.mkdir(CONTRIB_DIR)
util.mkdir(DOWNLOADS)

# Try to get Pyccuracy locally first, so we don't have to clone the repo 
# unnecessarily. 
dl_source = os.path.join(DOWNLOADS, INSTALL_DIR_NAME)
if not os.path.isdir(dl_source):
    os.system('git clone git://github.com/heynemann/pyccuracy.git %s/' \
              'pyccuracy' % DOWNLOADS)

# Now that we've cloned the source, copy it to the virtualenv's sources folder, 
# removing any old code first. 
dst_source = os.path.join(CONTRIB_DIR, INSTALL_DIR_NAME)
if os.path.isdir(dst_source):
    shutil.rmtree(dst_source)
shutil.copytree(dl_source, dst_source)

# Create symlinks.
os.chdir(os.path.join(util.get_virtualenv(), 
                      'lib/python%s/site-packages' % util.get_python_version()))
os.system('ln -s ../../../%s/pyccuracy/pyccuracy' % REL_CONTRIB_PATH)
os.chdir(os.path.join(util.get_virtualenv(), 'bin'))
os.system('ln -s ../%s/pyccuracy/pyccuracy/pyccuracy_console.py ' \
          'pyccuracy_console' % REL_CONTRIB_PATH)
os.system('ln -s ../%s/pyccuracy/pyccuracy/pyccuracy_help.py ' \
          'pyccuracy_help' % REL_CONTRIB_PATH)
