# Title:        up-question2answer.sh
#
# Description:  Setup the PHP-based Question2Answer app. 
#
# Author:       Matthew Norris
#
# Reference:    http://www.question2answer.org/advanced.php
#

DOWNLOADS=$HOME/dev/downloads # download the file here
RDIR=http://www.question2answer.org # the file's remote dir
FILE=question2answer-latest.zip # the file
DST_DIR="." # default destination dir
DST_ROOT="question2answer"

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
    echo "up-question2answer"
    echo "Usage: `basename $0` [options...]"
    echo "Options:"
    echo "  -d/--dst      Destination directory"
    echo "  -n/--name     New root directory name. Default is 'question2answer'."
    echo "  -h/--help     Output this message"
    
    exit 1
}

################################################################################
# Command line processing
################################################################################

# Parse the command line arguments. 
while [ "$#" -gt "0" ]; do
    case "$1" in 
        -d|--dst)
            shift 1
            DST_DIR="$1"
            #echo "Dst: $DST_DIR"
            shift 1
            ;;
        -n|--name)
            shift 1
            NEW_NAME="$1"
            #echo "New name: $NEW_NAME"
            shift 1
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
# Main
################################################################################

# Download the file. 
mkdir -p $DOWNLOADS
cd $DOWNLOADS

echo "Getting $FILE..."

# Get the file if it does not exist
if [ ! -f $FILE ]; then
	echo "Downloading from $RDIR..."
	wget $RDIR/$FILE
fi
echo "Done."

# Unzip it. 
echo "Unzipping $FILE..."
mkdir -p $DST_DIR
unzip -q $FILE -d $DST_DIR
echo "Done."

cd $DST_DIR

# Rename if necessary. 
if [ -n "$NEW_NAME" ]; then
    echo "Renaming $DST_ROOT to $NEW_NAME..."
    mv $DST_ROOT $NEW_NAME
    echo "Done."
    DST_ROOT=$NEW_NAME
fi

cd $DST_ROOT

# Create config files from the provided examples.  
cp qa-config-example.php qa-config.php
mv qa-external-example qa-external

echo
echo "TO FINISH THE INSTALLATION:"
echo
echo "1. Edit qa-config.php to include MySQL details at the top, " 
echo "   scroll down and set QA_EXTERNAL_USERS to true, then save the file."
echo "2. Visit http://www.question2answer.org/advanced.php "
echo "   and follow steps 7-11."
echo