# Title:        up-other-tools.sh
# Description:  Setup useful tools and utilities
# Author:       Matthew Norris
# Reference:    http://live.gnome.org/GeditPlugins

# sudo aptitude install agave -y
sudo aptitude install curl -y
sudo aptitude install gedit-plugins -y
sudo aptitude install inkscape -y
sudo aptitude install keepassx -y
sudo aptitude install unrar -y
sudo aptitude install virtualbox-ose -y

# NetBeans UML "sometimes" deletes a header file, rendering your UML documents 
# useless; evaluating PyDev & PyUML for Eclipse instead.
# Reference: http://www.nabble.com/-j2ee--High-CPU-usage-td14170525.html

#sudo aptitude install netbeans -y
