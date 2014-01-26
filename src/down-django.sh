# Title:        down-django.sh
# Description:  Remove Django
# Author:       Matthew Norris
# Reference:    http://www.djangoproject.com/download/
#               http://weboom.wordpress.com/2009/07/01/how-to-uninstall-django/

#SOURCES=~/sources
#SDKS=/opt/dev/sdks
#TOOLS=/opt/dev/tools

#DJANGO_TAR=http://www.djangoproject.com/download/1.0.2/tarball/
#DJANGO_FILENAME=Django-1.0.2-final

#sudo aptitude remove python-django -y

# Version 1.1
sudo rm -fr /usr/lib/python2.5/site-packages/django

# TODO: For some reason, it looks like Django didn't install in either place, 
# yet I can still import it in the python console

sudo rm -fr /usr/lib/python2.6/dist-packages/django
sudo rm -fr /usr/lib/python2.6/site-packages/django

sudo rm /usr/bin/django-admin.py
