"""
Installs Pyjamas in a virtual environment.

@see: http://pyjs.org/getting_started.html
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

url = util.URL('http://downloads.sourceforge.net/project/pyjamas/pyjamas/0.7pre1/pyjamas-0.7pre1.tgz')
dl_file = os.path.join(DOWNLOADS, url.basename)

REL_CONTRIB_PATH = 'modules/contrib'    
CONTRIB_DIR = os.path.join(util.get_virtualenv(), REL_CONTRIB_PATH)
util.mkdir(CONTRIB_DIR)

# If the file is not already present, download it. 
if not os.path.isfile(dl_file):
    print 'Downloading %s...' % url.basename 
    dl_file = url.download(dstdir=DOWNLOADS)
    print 'Done.\n'

# Install and create symlinks.
print 'Installing pyjamas...'     

pyjamas = util.Archiver(dl_file)
pyjamas.extract(dstdir=CONTRIB_DIR)
os.chdir(os.path.join(CONTRIB_DIR, url.rootname))
os.system('python bootstrap.py')

print 'Done.\n'
print 'Creating symlinks...'

os.chdir(os.path.join(util.get_virtualenv(), 'bin'))
os.system('ln -s ../%s/%s/bin/pyjsbuild' % (REL_CONTRIB_PATH, url.rootname))
os.system('ln -s ../%s/%s/bin/pyjscompile' % (REL_CONTRIB_PATH, url.rootname))

print 'Done.\n'