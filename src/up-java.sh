# Title:        up-java.sh
# Description:  Install the default Java JDK (for 64-bit) and the 32-bit Java 
#               runtime for applications that need the 32-bit environment 
#               (like RubyMine)
# Author:       Matthew Norris

# Add this repo to be able to run Hadoop. 
# https://docs.cloudera.com/display/DOC/Java+Development+Kit+Installation
sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"
sudo aptitude update

# Install Java & its 32-bit version also. 
sudo aptitude install sun-java6-jdk sun-java6-plugin -y
#sudo aptitude install ia32-sun-java6-bin -y
