# Title:        up-pydev.sh
# Description:  Setup PyDev and Eclipse
# Author:       Matthew Norris
# Reference:    

sudo aptitude install eclipse-pydev -y

# TODO: Right now, to install plugins in eclipse this way, you must run 
# 'sudo eclipse' so that you have access to the plugins directory (controlled 
# by root).  You may be able to change the group on the directory and sub-
# directories like with Google App Engine.  
