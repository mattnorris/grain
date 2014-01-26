"""
Sets up the project structure for the virtual environment. 

@see: U{https://sites.google.com/a/poprop.com/wiki/build/python}
"""
import os
import sys

sys.path.append(os.path.join(os.environ['HOME'], 'dev/modules'))
from poprop import util

__author__ = "Matthew Norris"
__copyright__ = "Copyright 2011, Matthew Norris"

if not util.in_virtualenv():
    sys.exit('Script not running in a virtual environment. Exiting.')

print 'Generating folder structure...'

project_dir = util.mkdir(os.path.join(util.get_virtualenv(), 'project'))
util.mkdir(os.path.join(project_dir, 'docs'))
util.mkdir(os.path.join(project_dir, 'app'))
util.mkdir(os.path.join(project_dir, 'scripts'))

tests_dir = util.mkdir(os.path.join(project_dir, 'tests'))
#util.mkdir(os.path.join(tests_dir, 'mocks'))
#util.mkdir(os.path.join(tests_dir, 'unit'))
#util.mkdir(os.path.join(tests_dir, 'fixtures'))
#util.mkdir(os.path.join(tests_dir, 'functional'))
#util.mkdir(os.path.join(tests_dir, 'acceptance'))

print 'Done.'
