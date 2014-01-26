import os
import sys

sys.path.append(os.path.join(os.getenv('DEV_HOME'), 'modules'))
from poprop.util import Installer

################################################################################
#
# Title:         remove_python.sh
# Description:   Remove Python 2.5, dev tools for Python 2.5 & 2.6, and other
#                Python utilties. 
# Author:        Matthew Norris
# Reference:
#
################################################################################

print 'Removing virtualenvwrapper...'
os.system('sudo easy_install -m virtualenvwrapper')
print 'Done.\n'

print 'Removing virtualenv...'
os.system('sudo easy_install -m virtualenv')
print 'Done.\n'

# Remove setuptools. 
# TODO: Not sure how to do this: 
#       http://www.eby-sarna.com/pipermail/peak/2006-February/002450.html

packages = ['python2.5', 'python2.5-dev', 'python2.6-dev', 'python-docutils']
installer = Installer(packages)
installer.remove_seq()

os.system('sudo aptitude remove python-lxml')
