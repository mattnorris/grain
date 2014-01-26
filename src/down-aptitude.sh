# Title:        down-aptitude.sh
# Description:  Remove extra aptitude libraries
# Author:       Matthew Norris

sudo aptitude remove libxslt1-dev libxml2-dev -y
sudo aptitude remove build-essential -y
