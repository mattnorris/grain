#!/bin/bash
# Title:        move-scripts-to-system.sh
# Description:  Move the specified directory of scripts to "production", 
#               the user's scripts directory.   
# Author:       Matthew Norris
# References:   http://www.thegeekstuff.com/2010/09/rsync-command-examples/
#               http://www.linuxquestions.org/questions/linux-newbie-8/recursively-cp-all-directories-files-and-hidden-files-808403/#post3972438
#

rsync -azvru "$1/." "$2/dev/scripts"
#cp -a $1/. "$2/dev/scripts"
