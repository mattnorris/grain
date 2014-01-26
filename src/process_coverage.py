"""
Removes unwanted elements from the given XML file and creates a new XML file. 
"""
import os
import sys

sys.path.append(os.path.join(os.environ['HOME'], 'dev/modules'))
from poprop.util import XMLFormatter

print sys.argv

print 'Formatting coverage report...'

# See http://www.regular-expressions.info/lookaround.html
formatter = XMLFormatter(sys.argv[1])
#newxml = formatter.keep('package', 'name', 'poprop(?!\(.contrib|_)|tests', 
#                        sys.argv[2])
newxml = formatter.coverage_keep('package', 'name', ['poprop'], 
                        sys.argv[2])
print 'Done'
print '%s rewritten as %s' % (formatter.path, newxml)