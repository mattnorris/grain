# Title:        up-shapado.sh
#
# Description:  Installs the Shapado project from source in a subfolder named 
#               "shapado" or to a directory of your choice. 
#               PREREQUISITES: This script assumes Ruby, its gems, Rails 2.3.8, 
#               and MongoDB are already installed.
# 
#               See https://sites.google.com/a/poprop.com/wiki/build/shapado
#
# Author:       Matthew Norris
#

PROJECT_NAME="shapado"

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
    echo "up-shapado"
    echo "Usage: `basename $0` [options...]"
    echo "Options:"
    echo "  -n/--name     Specify the project name"
    echo "  -h/--help     Output this message"
    
    exit 1
}

################################################################################
# Command line processing
################################################################################

# Parse the command line arguments. 
while [ "$#" -gt "0" ]; do
    case "$1" in 
        -n|--name)
            shift 1
            PROJECT_NAME="$1"
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

git clone git://gitorious.org/shapado/shapado.git $PROJECT_NAME

cp $PROJECT_NAME/config/shapado.sample.yml $PROJECT_NAME/config/shapado.yml
cp $PROJECT_NAME/config/database.yml.sample $PROJECT_NAME/config/database.yml

cd $PROJECT_NAME
sudo rake gems:install
script/update_geoip
rake bootstrap
