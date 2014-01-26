# Title:        down-ruby.sh
# Description:  Tear down the Ubuntu Ruby on Rails development environment
# Author:       Matthew Norris
# Reference:    http://articles.slicehost.com/2008/11/28/ubuntu-intrepid-setup-page-2
#               http://articles.slicehost.com/2009/1/6/ubuntu-intrepid-ruby-on-rails
#               http://geekystuff.net/2009/1/14/remove-all-ruby-gems

LOG_NAME="installed-gems"

################################################################################
# Gems
################################################################################

# Check for 'UNINSTALL' directory.  If one does not exist, make one to save 
# notes from the uninstallation.

UNINSTALL=~/uninstall

if [ ! -d $UNINSTALL ]
  then
    mkdir $UNINSTALL
fi

# Save a list of all the installed gems 
gem list --no-versions > "$UNINSTALL/$LOG_NAME.log"
gem list > "$UNINSTALL/$LOG_NAME-with-versions.log"

# Uninstall all gems and executables
# Reference: http://geekystuff.net/2009/1/14/remove-all-ruby-gems

gem list --no-versions | xargs sudo gem uninstall -aIx

# Uninstall the gems and all applicable executables without confirmation (-x).
#sudo gem uninstall [package-name] -x

################################################################################
# Ruby on Rails
################################################################################

# Remove the rubygems symlink and *manually* uninstall rubygems (we cannot 
# simply call 'sudo aptitude remove rubygems' because we did not uninstall it 
# using aptitude, we installed it manually).

sudo rm -fv /usr/bin/gem1.8 /usr/bin/gem
sudo rm -rfv /usr/lib/ruby/gems

# Remove the other symlinks.

sudo rm -v /usr/bin/ruby
sudo rm -v /usr/bin/ri
sudo rm -v /usr/bin/rdoc
sudo rm -v /usr/bin/irb

# Remove Ruby

sudo aptitude remove ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby sqlite3 libsqlite3-ruby1.8 -y
