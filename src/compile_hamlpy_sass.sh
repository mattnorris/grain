#!/bin/bash
################################################################################
# 
# Description:  Eclipse uses "Builders" to build projects. These Builders can 
#               fire scripts and Ant tasks to accomplish various tasks. This 
#               script compiles Haml & Sass files into regular HTML & CSS. 
#
# Usage:        compile_hamlpy_sass [files created] [files updated] [files deleted]
# 
# Requirements: Hamlpy & Sass must be installed globally on your machine.
# 
#               http://github.com/jessemiller/HamlPy/blob/master/reference.md
#               http://sass-lang.com/tutorial.html
# 
# Author:       Matthew Norris
# 
# References:   Eclipse Builders: http://stackoverflow.com/questions/1012230/eclipse-on-save-execute-a-program/1012281#1012281
#               Eclipse Builders tutorial: http://www.ibm.com/developerworks/opensource/tutorials/os-eclipse-tools/section4.html
#               Incrementing in bash script: http://www.unix.com/shell-programming-scripting/77028-how-create-incrementing-counter.html
#               Get file extension: http://liquidat.wordpress.com/2007/09/29/short-tip-get-file-extension-in-shell-script/#comment-35771
#               Split string by char & iterate: http://stackoverflow.com/questions/918886/split-string-based-on-delimiter-in-bash/918931#918931
# 
################################################################################

################################################################################
# Functions
################################################################################

# Compile the file with the given command, or delete it if the count is 3. 
#
# arg1: command
# arg2: source file
# arg3: file extension for target file
#
function handleFile {
	command=$1
    input=$2
    output="${2%.*}.$3"
    
    if [ $BLANK_COUNT -lt 3 ]; then
    	echo -e "Updated:\t$input"
        echo -e "Compiling:\t$output"
        
        $command $input $output
    else
        echo -e "Deleted:\t$input"
        echo -e "Deleting:\t$output"
        
        rm $output
    fi
}

# Loop through the given files, compiling and .haml or .hamlpy files to HTML 
# and .scss or .sass files to CSS. 
# 
# @see: http://stackoverflow.com/questions/918886/split-string-based-on-delimiter-in-bash/918931#918931
# 
# arg1: list of filenames separated by spaces
#
function checkFiles {
    IFS=' ' read -ra ADDR <<< "$1"
    for file in "${ADDR[@]}"; do 
        fext="${file##*.}"
        if [ $fext = "haml" ] || [ $fext = "hamlpy" ]; then
            handleFile "hamlpy" $file "html"
        elif [ $fext = "scss" ] || [ $fext = "sass" ]; then
            handleFile "sass" $file "css"
        fi
    done
}

################################################################################
# Main
################################################################################

# The corresponding Eclipse Builder's arguments are structured like this: 
#
#     "${build_files:a,f}" "${build_files:c,f}" "${build_files:r,f}"
#
# Because any one of these 3 arguments (or all of them) can be blank, we have 
# to account for 4-6 arguments without knowing exactly how many. We do, however,
# know that they will always be in the order: created, updated, deleted.

echo "Build complete. Script was passed $# arguments."
echo

# Loop through the parameters. If a blank is encountered, increment; this way 
# we know if we should be creating (1), updating (2), or deleting (3) files.

BLANK_COUNT=0 
for arg in "$@"
do 
	if [ "$arg" = "" ]; then
	   BLANK_COUNT=`expr $BLANK_COUNT + 1`
    else
        checkFiles "$arg"
    fi
done 

echo
echo "Done."
