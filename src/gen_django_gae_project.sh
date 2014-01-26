# Title:        start-gae-django-project.sh
# Description:  This project provides a helper that eases the process of 
#               creating a Django project to run on the Google App Engine. It's 
#               based off of the Googlers' project at 
#               http://code.google.com/p/google-app-engine-django/
# Author:       Matthew Norris
# Reference:    http://code.google.com/p/google-app-engine-django/
#               http://realm3.com/articles/installing_django_from_source_on_ubuntu_8.10
#               http://ubuntuforums.org/showthread.php?t=83877
#               http://sites.google.com/site/io/rapid-development-with-python-django-and-google-app-engine

################################################################################
# Files & locations
################################################################################

# System directories
SOURCES=~/sources
SOURCE_DIR=~/dev/source
PROJECT_NAME=$USER"sapp"
SDKS=/opt/dev/sdks

# Google code website 
GOOGLE_CODE_SITE="http://google-app-engine-django.googlecode.com/files"
AEFD_REV_NO=86 #52
AEFD_DIR_NAME="appengine_helper_for_django"
AEFD_FILE="$AEFD_DIR_NAME-r$AEFD_REV_NO.zip"

# Django code website 
DJANGO_REV_NO=1.0.2
DJANGO_FILE_NAME=Django-$DJANGO_REV_NO-final
DJANGO_DOWNLOAD=http://www.djangoproject.com/download/$DJANGO_REV_NO/tarball/

# TODO: Add options for using the stable Django

################################################################################
# Setup the helper project
################################################################################

# Check for 'sources' directory.  If one does not exist, make one.

if [ ! -d $SOURCES ]
  then
    mkdir $SOURCES
fi

# Download and bootstrap the project
echo
echo "Downloading $AEFD_FILE..."

cd $SOURCES
if [ ! -f $AEFD_FILE ] 
  then 
    wget $GOOGLE_CODE_SITE/$AEFD_FILE
  else
    echo "...$AEFD_FILE has already been downloaded."
fi

echo
echo "Unzipping $AEFD_FILE..."

unzip $AEFD_FILE -d $SOURCE_DIR

# Check to see if the user provided a project name.

if [ -n "$1" ]
  then
    PROJECT_NAME="$1"
fi

echo
echo "Renaming project directory to $PROJECT_NAME and linking the App Engine SDK..."

# Check to see if the project name exists already.

if [ -d $SOURCE_DIR/$PROJECT_NAME ] 
  then 
    echo
    echo "$PROJECT_NAME directory already exists.  Creating a new project directory name."
    PROJECT_NAME="$PROJECT_NAME-$RANDOM"
fi

mv $SOURCE_DIR/$AEFD_DIR_NAME $SOURCE_DIR/$PROJECT_NAME
ln -s $SDKS/google_appengine $SOURCE_DIR/$PROJECT_NAME/.google_appengine

# If the revision number is greater than 52, we need to copy the Django code 
# into the project so App Engine can use it.

cd $SOURCES
if [ $AEFD_REV_NO -gt 52 ]
  then
    echo
    echo "Downloading $DJANGO_FILE_NAME..."
    if [ ! -f $DJANGO_FILE_NAME.tar.gz ] 
      then 
        wget $DJANGO_DOWNLOAD
      else
        echo "...$DJANGO_FILE_NAME has already been downloaded."
    fi

    echo
    echo "Moving Django code into $PROJECT_NAME directory..."

    tar -xzvf $DJANGO_FILE_NAME.tar.gz
    cd $DJANGO_FILE_NAME
    zip -r $SOURCE_DIR/$PROJECT_NAME/django.zip django

    echo
    echo "Removing $DJANGO_FILE_NAME files..."

    cd ..
    rm -fr $DJANGO_FILE_NAME
fi

# Tell the user to perform the last manual step.

echo
echo "Edit the application line in app.yaml to match the name you registered your application under in the Admin Console."
echo
echo "Run manage.py to start a new application for your code:"
echo
echo "  python manage.py startapp myapp"
