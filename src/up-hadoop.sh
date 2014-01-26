# Reference: http://archive.cloudera.com/docs/_apt.html

DISTRO="lucid"
SOURCES_DIR="/etc/apt/sources.list.d"
LIST="cloudera.list"

echo "Writing new sources list for '$DISTRO' to $LIST..."
echo "deb http://archive.cloudera.com/debian $DISTRO-cdh3 contrib" > $LIST
echo "deb-src http://archive.cloudera.com/debian $DISTRO-cdh3 contrib" >> $LIST
sudo mv $LIST $SOURCES_DIR
echo "Done."
echo

echo "Adding repository key..."
curl -s http://archive.cloudera.com/debian/archive.key | sudo apt-key add -
echo "Done."
echo 

echo "Updating apt-get..."
sudo apt-get update
echo "Done."
echo

echo "Installing Hadoop..."
apt-cache search hadoop
sudo apt-get install hadoop -y
echo "Done."
echo 
