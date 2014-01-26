# Title:        up-aptitude.sh
# Description:  Update aptitude
# Author:       Matthew Norris
# Reference:    http://articles.slicehost.com/2008/11/28/ubuntu-intrepid-setup-page-2

# Now we can update the sources so we have the latest list of software packages.

sudo aptitude update
# NOTE: If you have used the .bashrc shown above you just need to enter 'update'
# because the alias will use the entire command.  The entire command is included
# for clarity.

# If Intrepid is a bare bones, we will need to set the system locale.
#sudo locale-gen en_US.UTF-8
#sudo /usr/sbin/update-locale LANG=en_US.UTF-8

# Let's see if there are any upgrade options

sudo aptitude safe-upgrade
sudo aptitude full-upgrade

# Ubuntu Intrepid has some handy meta-packages that include a set of pre-defined
# programs needed for a single purpose.  So instead of installing a dozen
# different package names, you can install just one meta-package. One such
# package is called 'build-essential'.  

sudo aptitude install build-essential -y
# NOTE: gcc, make, patch, and other programs are installed. All these are
# needed for many other programs to install properly.

# Install these XML processing libraries.  We will use them for Cucumber.
# Reference: http://pragmatig.wordpress.com/2008/12/25/getting-started-with-cucumber-on-ubuntu/
sudo aptitude install libxslt1-dev libxml2-dev -y
