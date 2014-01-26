# Title:        up-django.sh
# Description:  Setup Django for use with Python
# Author:       Matthew Norris
# Reference:    http://www.djangoproject.com/download/

SOURCES=~/sources
SDKS=/opt/dev/sdks
TOOLS=/opt/dev/tools

#DJANGO_TAR=http://www.djangoproject.com/download/1.0.2/tarball/
DJANGO_TAR=http://www.djangoproject.com/download/1.1/tarball/
#DJANGO_FILENAME=Django-1.0.2-final
DJANGO_FILENAME=Django-1.1

#sudo aptitude install python-django -y

# Version 1.1
# Check for 'sources' directory.  If one does not exist, make one.

if [ ! -d $SOURCES ]
  then
    echo "Making the $SOURCES directory.."
    mkdir $SOURCES
fi

echo "Downloading $DJANGO_FILENAME..."
cd $SOURCES
if [ ! -f $DJANGO_FILENAME.tar.gz ] 
  then 
    wget $DJANGO_TAR
    echo "Done."
  else
    echo "...$DJANGO_FILENAME.tar.gz has already been downloaded."
fi

echo "Installing $DJANGO_FILENAME for python2.5 and python2.6..."
tar -zxvf $DJANGO_FILENAME.tar.gz
sudo python2.6 $DJANGO_FILENAME/setup.py install
sudo python2.5 $DJANGO_FILENAME/setup.py install
echo "Done."

echo "Cleaning up..."
sudo rm -fr $DJANGO_FILENAME
echo "Done."
