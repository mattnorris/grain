# Title:        up-wxpython.sh
# Description:  Remove wxPython for GUIs
# Author:       Matthew Norris

echo "Removing wxPython..."
sudo aptitude remove python-wxgtk2.8 -y
echo "Done."
