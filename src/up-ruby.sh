# Title:        up-dev-tools.sh
#
# Description:  Setup Ubuntu with an integrated, automated 
#               Ruby on Rails development environment
#
# Author:       Matthew Norris
#
# Reference:    http://articles.slicehost.com/2008/11/28/ubuntu-intrepid-setup-page-2
#               http://articles.slicehost.com/2009/1/6/ubuntu-intrepid-ruby-on-rails
#               http://www.claytonlz.com/index.php/2009/04/how-to-setup-rspec-cucumber-webrat-rcov-and-autotest-on-leopard/
#               http://github.com/guides/providing-your-ssh-key
#               No ri/rdoc option - http://bit.ly/cLSaR7
#

# Installing all gems' documentation is time-consuming. By default, 
# don't install it. See http://bit.ly/cLSaR7 for more details. 
INSTALL_DOC="--no-ri --no-rdoc"

################################################################################
# Helper functions 
################################################################################

function errorMessage() {
    echo -e "Error: $1"
    exit 1
}

function warningMessage() {
    echo -e "Warning: $1"
    exit 2
}

function outputUsage() {
    echo "up-ruby"
    echo "Usage: `basename $0` [options...]"
    echo "Options:"
    echo "  --railsv/--railsversion     Specify Rails version to install"
    echo "  -d/--doc                    Install ri and rdoc for all gems"
    echo "  -h/--help                   Output this message"
    
    exit 1
}

################################################################################
# Command line processing
################################################################################

# Parse the command line arguments. Specifically, we're checking for a 
# Rails version because Shapado requires Rails 2.3.8: http://bit.ly/d8OMtX 
while [ "$#" -gt "0" ]; do
    case "$1" in 
    	--railsv|--railsversion)
    	   shift 1
    	   RAILS_VERSION="$1"
    	   shift 1
    	   ;;
    	-d|--doc)
    	   shift 1
    	   INSTALL_DOC=""
    	   ;;
    	--shapado)
    	   # Defaults for the OS project "Shapado". See http://bit.ly/d8OMtX
    	   shift 1
    	   RAILS_VERSION="2.3.8"
    	   errorMessage "Shapado option is not yet implemented."
    	   ;;
        -h|--help)
          outputUsage
          ;;
        -*|--*)
          errorMessage "Unknown option $1."
          ;;
        *)
          errorMessage "Unknown parameter $1."
          ;;
    esac
done

################################################################################
# Ruby 
################################################################################

SOURCES=~/dev/downloads   # sources directory
RUBYFORGE=http://rubyforge.org/frs/download.php/70696  # download location
RUBYGEMS_VERSION=rubygems-1.3.7   # software version

# The process will involve a mix of installation methods - the main ruby 
# packages and dependencies will be installed using the 'aptitude' package 
# manager but rubygems will be install from source.  The reason for this is that
# it is important to get the latest and most stable version of rubygems and the
# easiest way to do that is by installing from source.

sudo aptitude install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 \
	libreadline-ruby1.8 libruby1.8 libopenssl-ruby sqlite3 libsqlite3-ruby1.8 -y

# Create symlinks from the install to locations every program would look.

sudo ln -s /usr/bin/ruby1.8 /usr/bin/ruby
sudo ln -s /usr/bin/ri1.8 /usr/bin/ri
sudo ln -s /usr/bin/rdoc1.8 /usr/bin/rdoc
sudo ln -s /usr/bin/irb1.8 /usr/bin/irb

# Check for 'sources' directory.  If one does not exist, make one so we can 
# install rubygems from source.

if [ ! -d $SOURCES ]
  then
    mkdir $SOURCES
fi

# Install rubygems from source.

# TODO: Overwrite or remove an old file of the same name first
cd $SOURCES
wget $RUBYFORGE/$RUBYGEMS_VERSION.tgz
tar xzvf $RUBYGEMS_VERSION.tgz
cd $RUBYGEMS_VERSION

sudo ruby setup.rb

# Make another symlink 

sudo ln -s /usr/bin/gem1.8 /usr/bin/gem

# Update

sudo gem update
sudo gem update --system

################################################################################
# Gems
################################################################################

# Install useful gems.
# Reference: http://www.claytonlz.com/index.php/2009/04/how-to-setup-rspec-cucumber-webrat-rcov-and-autotest-on-leopard/

# If Rails version is null or whitespace, install default version. 
if [ -z "$RAILS_VERSION" ] || [ ! -n "$RAILS_VERSION" ]; then
    echo "Installing default Rails version..."
    sudo gem install rails $INSTALL_DOC	
    sudo gem install rspec $INSTALL_DOC
    sudo gem install rspec-rails $INSTALL_DOC
else 
    echo "Installing Rails version $RAILS_VERSION..."
    sudo gem install rails -v="$RAILS_VERSION" $INSTALL_DOC
    echo "Done."
    
    RSPEC_VERSION="1.2.9"
    echo "Installing Rspec version $RSPEC_VERSION." 
    echo "See http://github.com/dchelimsky/rspec/wiki/rails for more details."
    
    sudo gem install rspec -v="$RSPEC_VERSION" $INSTALL_DOC
    sudo gem install rspec-rails -v="$RSPEC_VERSION" $INSTALL_DOC
    
    echo "Done."
fi

# Install cucumber; also installs these 6 gems: 
#
# term-ansicolor-1.0.3
# polyglot-0.2.5
# treetop-1.2.5
# diff-lcs-1.1.2
# builder-2.1.2
# cucumber-0.3.1

sudo gem install cucumber $INSTALL_DOC

# Install the rest of our testing suite

sudo gem install webrat $INSTALL_DOC # will also install nokogiri-1.2.3
sudo gem install rcov $INSTALL_DOC
sudo gem install ZenTest $INSTALL_DOC

# Install Haml & Sass
sudo gem install haml $INSTALL_DOC
sudo gem install rb-inotify $INSTALL_DOC # notifies you of --watch events 
	
# Dependencies for Shapado. 
# See http://shapado.com/questions/cmo-se-configura-shapado
sudo gem install faker $INSTALL_DOC
sudo gem install gemcutter $INSTALL_DOC
# sudo gem tumble # This command is deprecated, Gemcutter.org is the primary source for gems.

################################################################################
# Test your installation with these commands
################################################################################

# $ruby -v
# $rails -v
# $gem -v

# $irb
# irb(main):005:0> require 'sqlite3'
# => true
