"""
Installs color palettes for OpenOffice.org and Inkscape. 
"""
import os
import tempfile

from poprop.util import URL
from poprop.brand.color import Palette

__author__ = "Matthew Norris"
__copyright__ = "Copyright 2011, Matthew Norris"

REMOTE_FILE = 'http://spreadsheets.google.com/pub?key=ta0-PKPDYY90bjEIAh8tmOg' \
                '&single=true&gid=1&output=txt'
PALETTE_NAME = 'poprop'

# Download TSV file
print 'Downloading palette source...'
url = URL(REMOTE_FILE)
palpath = url.download(newname='%s.tsv' % PALETTE_NAME, 
                       dstdir=tempfile.mkdtemp())
print 'Done.\n'

# Create the palette files. 
pal = Palette()
pal.read(palpath)

oo_palette = os.path.join(os.environ['HOME'], 
                     '.openoffice.org/3/user/config/%s.soc' % PALETTE_NAME)
print 'Installing OpenOffice.org palette...'
pal.write_openoffice(oo_palette)
print 'Done.\n'

# Because Inkscape requires root permission, we cannot write directly. 
print 'Installing Inkscape palette...'
tmpfile = os.path.join(tempfile.mkdtemp(), PALETTE_NAME)
pal.write_inkscape(tmpfile)
os.system('sudo mv %s %s' % (tmpfile, 
                             '/usr/share/inkscape/palettes/%s.gpl' % 
                             PALETTE_NAME))
print 'Done.\n'