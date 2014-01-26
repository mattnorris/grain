"""
Removes custom color palettes from OpenOffice.org and Inkscape. 
"""
import os

__author__ = "Matthew Norris"
__copyright__ = "Copyright 2011, Matthew Norris"

PALETTE_NAME = 'poprop'

print 'Removing palettes...'
try:
    os.system('sudo rm /usr/share/inkscape/palettes/%s.gpl' % PALETTE_NAME)
    os.remove(os.path.join(os.environ['HOME'], 
                           '.openoffice.org/3/user/config/%s.soc' % 
                           PALETTE_NAME))
except OSError, ose:
    print 'Some files not present; skipping...'
print 'Done.\n'