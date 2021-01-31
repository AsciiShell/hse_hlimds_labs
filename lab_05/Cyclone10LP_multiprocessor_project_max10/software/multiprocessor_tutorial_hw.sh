#!/bin/sh

# AUTHOR:       soreilly
# DATA:         05/12/2011
# DESCRIPTION:  A script that contains a bunch of app and bsp switches that will generate 
#		the makefiles, compile the code, download the code, open a terminal.
#               Pass in a cable number if you have multiple programming cables.
#
# 		Usage:    ./multiprocessor_tutorial.sh <optional cable number>
#               Example:  ./multiprocessor_tutorial.sh 2
#
#               Tip: Type 'jtagconfig -n' to list all the jtag cables connected 
#		to the host (or remote cables).

# Name of the sof files
#SOF_NAME=multiprocessor_tutorial.sof
SOF_NAME=top.sof

# SOPC_DIR is used for the sof file location 
SOPC_DIR=..

# Check the number of arguments passed into the script
if [ $# -ne 1 ]
then
	CABLE_NUMBER="1"
else
	CABLE_NUMBER=$1
	echo "Cable number is " $CABLE_NUMBER
fi


# Downloading the sof file
cmd="nios2-configure-sof --cable $CABLE_NUMBER $SOPC_DIR/$SOF_NAME"
echo "Executing" $cmd
$cmd || {
    echo "Failed to download the .sof file."
    exit 1
}


