#!/usr/bin/env python

import os
import sys
import getpass

__author__ = "Matthew Norris"
__copyright__ = "Copyright 2011, Matthew Norris"

################################################################################
#
# Title:        gen_install_script.py
# Description:  Generates the skeleton of a bash installation script you can 
#               use to install and remove various development tools.
# Author:       Matthew Norris
# Reference:    Get current user's name in Python - http://bit.ly/n2ifWm
#
################################################################################

NAME_ARG_HELP = 'TOOLNAME'

DEFAULT_DIR = os.getenv("HOME")
name_conv = 'install-%s.sh'

file_contents = """#!/bin/bash
# Title:        %s
# Description:  TODO: Write description of what this script does.   
# Author:       %s
# Reference:    TODO: Record any references, like URLs, here. 
#

################################################################################
# Helper functions 
################################################################################

# Prints the given error message and exits.
function errorMessage() {
    echo -e "Error: $1. Type '`basename $0` -h' for usage and options."
    exit 1
}

# Prints the given warning message and exits.
function warningMessage() {
    echo -e "Warning: $1."
    exit 2
}

# Prints this script's usage and exists. 
function outputUsage() {
    echo "Usage: `basename $0` [options...]"
    echo "Options:"
    echo "  -h/--help     Prints this message"
    
    # TODO: Add help messages for your options here. 
    
    exit 1
}

################################################################################
# Installation functions 
################################################################################

# Installs packages and sets up directories and files. 
function installPackages() {
    # TODO: Write a setup function. 
    #echo "Installing `basename $0` tools & libraries..."
    echo "Function not implemented! Nothing was done!"
    #echo "Done."
    
    exit 0
}

# Removes packages installed and tears down any directories and files created. 
function removePackages() {
    # TODO: Write a tear down function.
    #echo "Removing `basename $0` tools & libraries..." 
    echo "Function not implemented! Nothing was done!"
    #echo "Done." 
    
    exit 0
}

################################################################################
# Command line processing
################################################################################

# Parse the command line arguments. 
while [ "$#" -gt "0" ]; do
    case "$1" in
     
    #   TODO:    Create some script options. 
    #   EXAMPLE: Uncomment below to assign a 'destination directory', DST_DIR, 
    #            to the arg given after a '-d' or '--dst' on the command line.
    # 
    #   -d|--dst)
    #       shift 1 # eat the '-d' or '--dst'
    #       DST_DIR="$1" # assign the next arg as this variable 
    #       shift 1 # eat the arg you just assigned
    #       ;;
        -r|--remove)
            shift 1
            removePackages
            ;;
        -h|--help)
            outputUsage
            ;;
        -*|--*)
            errorMessage "Unknown option $1"
            ;;
        *)
            errorMessage "Unknown parameter $1"
            ;;
    esac
done

################################################################################
# Main
################################################################################

# TODO: Write the main script here.

echo "Executing `basename $0`..."
installPackages
echo "Done."
 
""" 

def print_usage():
    """
    Prints the usage for this script. 
    """
    print "Usage: python %s %s [options...]\n" % \
        (os.path.basename(__file__), NAME_ARG_HELP)
    print "  -h/--help  Prints help message, usage, then exits"
    print "  -d         Directory and/or filename to save to/as"
    print "  -f         Forces file overwrite"
    print ""

def main():
    """
    Writes a new script file given a file name and options. 
    """    
    # Check for help first. 
    if '-h' in sys.argv or '--help' in sys.argv: 
        script_name = name_conv % NAME_ARG_HELP
        print "\nGenerates the file \'%s\' by convention and saves it to \n" \
            "'%s' by default\n" % (script_name, os.path.abspath(DEFAULT_DIR))
        print_usage()
        sys.exit(0)
        
    # Check for the TOOLNAME next. 
    try:
        name = sys.argv[1]
        
        # A name must be given first, not a flag. 
        if name.startswith('-'): 
            print '\nERROR! No %s provided. You must supply the name ' \
                'of the tool before supplying any options.\n' % NAME_ARG_HELP
            print_usage()
            sys.exit(1)
        
        # A name cannot be a file path or contain a directory. 
        if os.path.dirname(name):
            print '%s must not contain a directory.\n' % NAME_ARG_HELP
            print_usage()
            sys.exit(1)
            
        toolname = 'install-%s.sh' % name
        
    except IndexError:
        print '\nERROR! No %s provided. \'%s\' is the name of the tool ' \
            'for which you would like to create an installation script.\n' % \
            (NAME_ARG_HELP, NAME_ARG_HELP)
        print_usage()
        sys.exit(1)
        
    # Check for file or directory. 
    try:
        argpos = sys.argv.index('-d')
        path = sys.argv[argpos + 1]
        if os.path.isdir(path):
            # save to this dir instead of the default. 
            filepath = os.path.join(path, toolname)
        elif os.path.isfile(path):
            # Use this filename and location instead of the default. 
            filepath = os.path.abspath(path)
        else:
            # Use the -d option as the file name, but with the default dir. 
            filepath = os.path.join(DEFAULT_DIR, path)
    except IndexError:
        # No file or dir followed the -d option. 
        print 'No valid file or directory provided.\n'
        print_usage()
        sys.exit(1)
    except ValueError:
        # The -d option was not provided, so just use the default dir. 
        filepath = os.path.join(DEFAULT_DIR, toolname)
        
#    if '-f' in sys.argv: 
#        # Overwrite the file if it exists. 
#        overwrite = True
        
    # Exit if the file path already exists and the 'force' argument 
    # has not been explicitly provided.  
    if os.path.isfile(filepath) and not '-f' in sys.argv:
        print '%s exists. Use another file name ' \
            'or the \'-f\' option to overwrite.\n' % filepath
        sys.exit(1)
    
    # Configuration options for the bash file. 
    config = {'title': os.path.basename(filepath), 
              'author': getpass.getuser(), 
              }
    
    # Create the file, filling in the configuration data. 
    script_file = open(filepath, 'wb')
    script_file.write(file_contents % (config['title'], config['author']))
    script_file.close()
    
    # Make the file executable by anyone. http://bit.ly/qVe75R
    os.chmod(filepath, 0755)
    
    print 'Created \'%s\' and made it executable.' % filepath

if __name__ == '__main__':
    main()
    