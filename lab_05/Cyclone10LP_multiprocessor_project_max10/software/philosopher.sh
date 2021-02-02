#!/bin/sh
#
# AUTHOR:       soreilly
# DATA:         05/12/2011
# DESCRIPTION:  A script that contains a bunch of app and bsp switches that will generate the makefiles, 
#		compile the code, download the code, open a terminal.
#
#		The first parameter is the philosopher number cpu subsystem to target.
#               Pass in a jtag cable number as the second parameter if you have multiple jtag programming cables.
#
# 		Usage:      ./philosopher.sh <philosopher number> <optional cable number>
#               Example:    ./philosopher.sh 2
#               Tip: Type 'jtagconfig' to list all available jtag cables .

# Check the number of arguments passed into the script
if [ $# -eq 2 ]
then
	PHILOSOPHER_NUMBER=$1
  	CABLE_NUMBER=$2
else
	if [ $# -eq 1 ]
	then
		PHILOSOPHER_NUMBER=$1
		CABLE_NUMBER="1"
	else
  		echo ""
  		echo "Usage:    ./philosopher.sh <philosopher number> <optional cable number>"
		echo "Example:  ./philosopher.sh 2"
  		echo ""
		echo "Description:  A script that contains a bunch of app and bsp switches that will generate" 
		echo "the makefiles, compile the code, download the code, open a terminal."
  		echo "The first parameter is the philosopher number cpu subsystem to target."
  		echo ""
		echo "Pass in a jtag cable number as the second parameter if you have multiple jtag programming cables."
  		echo ""
		echo "Tip: Type 'jtagconfig -n' to see all available jtag cables."
  		exit 1
	fi
fi

if [ $PHILOSOPHER_NUMBER -gt 5 ]
then
	echo "Please specify a philosopher number between 0 and 4."
	exit 2
fi

# Convert numeric value for philosopher to a word spelling out that numeric value 
# to match against Nios II cpu component names in Qsys
# Used to derive cpu-name and STDIO assignments
if [ $PHILOSOPHER_NUMBER -eq 0 ]
then
	PHILOSOPHER_WORD="zero"
fi
if [ $PHILOSOPHER_NUMBER -eq 1 ]
then
	PHILOSOPHER_WORD="one"
fi
if [ $PHILOSOPHER_NUMBER -eq 2 ]
then
	PHILOSOPHER_WORD="two"
fi
if [ $PHILOSOPHER_NUMBER -eq 3 ]
then
	PHILOSOPHER_WORD="three"
fi
if [ $PHILOSOPHER_NUMBER -eq 4 ]
then
	PHILOSOPHER_WORD="four"
fi

# Name of elf file
ELF_NAME=test_code$PHILOSOPHER_NUMBER.elf

# JDI file name
JDI_FILE=top.jdi
#JDI_FILE=multiprocessor_tutorial.jdi

# Derive Nios II CPU and jtag uart Qsys component names for 1st 
# parameter specified philosopher subsystem number
# PHILOSOPHER_DOWNLOAD_CPU_NAME is a special case.  nios2-download 
# requires a philosopher cpu name specified without the sub-system 
# name pre-pended.  For this reason, each Nios II CPU component 
# in your Qsys design must have a unique cpu name.

PHILOSOPHER_CPU_NAME=philosopher_$PHILOSOPHER_WORD"_cpu_"$PHILOSOPHER_WORD
PHILOSOPHER_DOWNLOAD_CPU_NAME="cpu_"$PHILOSOPHER_WORD
PHILOSOPHER_JTAG_UART_NAME=philosopher_$PHILOSOPHER_WORD"_jtag_uart"

# cpu and jtag uart instance numbers
CPU_INSTANCE_NUMBER=$(($PHILOSOPHER_NUMBER+1))
JTAG_UART_INSTANCE_NUMBER=$(($PHILOSOPHER_NUMBER+1))

# These are the two folders where all the files are dumped
APP_DIR=app$PHILOSOPHER_NUMBER
BSP_DIR=bsp$PHILOSOPHER_NUMBER

# Source dir
SRC_DIR="./dining_philosophers_src"

echo "Philosopher number is " $PHILOSOPHER_NUMBER
echo "Philosopher cpu name is " $PHILOSOPHER_CPU_NAME
echo "Philosopher jtag uart name is " $PHILOSOPHER_JTAG_UART_NAME
echo "CPU instance number is " $CPU_INSTANCE_NUMBER
echo "Jtag_Uart instance number is " $JTAG_UART_INSTANCE_NUMBER
echo "Application directory is " $APP_DIR
echo "BSP directory is " $BSP_DIR
echo "ELF name is " $ELF_NAME

# BSP generation configuration

SOPC_DIR=..
OPTIMIZATION_LEVEL="-O2"
MEMORY_NAME=onchip_memory
SIMULATION_OPTIMIZED_SUPPORT="false"
BSP_TYPE=hal
BSP_FLAGS="--set hal.max_file_descriptors 4 \
--cpu-name $PHILOSOPHER_CPU_NAME \
--set hal.stdin $PHILOSOPHER_JTAG_UART_NAME \
--set hal.stdout $PHILOSOPHER_JTAG_UART_NAME \
--set hal.stderr $PHILOSOPHER_JTAG_UART_NAME \
--set hal.sys_clk_timer none \
--set hal.timestamp_timer none \
--set hal.enable_exit true \
--set hal.enable_c_plus_plus false \
--set hal.enable_clean_exit true \
--set hal.enable_reduced_device_drivers true \
--set hal.enable_lightweight_device_driver_api true \
--set hal.enable_small_c_library true \
--set hal.enable_sim_optimize $SIMULATION_OPTIMIZED_SUPPORT \
--set hal.make.bsp_cflags_optimization $OPTIMIZATION_LEVEL \
--default_sections_mapping $MEMORY_NAME"


# ******** DON'T NEED TO MODIFY ANYTHING BELOW THIS LINE **************

# make sure the application and bsp directories are blown away first before attempting to regenerate new projects
rm -rf $APP_DIR
rm -rf $BSP_DIR


# generate the BSP in the $BSP_DIR
cmd="nios2-bsp $BSP_TYPE $BSP_DIR $SOPC_DIR $BSP_FLAGS"
$cmd || {
  echo "nios2-bsp failed"
  exit 1
}


# generate the application in the $APP_DIR
cmd="nios2-app-generate-makefile --app-dir $APP_DIR --bsp-dir $BSP_DIR --elf-name $ELF_NAME --src-rdir $SRC_DIR --set APP_CFLAGS_OPTIMIZATION $OPTIMIZATION_LEVEL"
$cmd || {
  echo "nios2-app-generate-makefile failed"
  exit 1
}


# Running make (for application and the bsp due to dependencies)
cmd="make --directory=$APP_DIR"
echo "Executing" $cmd
$cmd || {
    echo "make failed"
    exit 1
}

# Downloading the code
#
# PHILOSOPHER_DOWNLOAD_CPU_NAME is a special case.  nios2-download --cpu_name
# switch requires a philosopher cpu name specified without the sub-system 
# name pre-pended.  For this reason, each Nios II CPU component 
# in your Qsys design must have a unique cpu name. For example, For cpu
# name philosopher_zero_cpu_zero, the name to use for nios2-download
# is cpu_zero.
#
# Alternatively, --instance can be used instead of --cpu-name switch; 
# however, use of --cpu-name does not require Quartus II derived 
# instance number assignments.  --instance does use the Quartus II
# derived instance numbers.  --jdi switch is required when using 
# --cpu-name switch.  Note that nios2-terminal requires --instance,
# and does not support --cpu-name switch.  The following cmd
# assignment shows nios2-download with --instance instead of --cpu-name.
#
# cmd="nios2-download -g -r --instance $CPU_INSTANCE_NUMBER \
#      --cable $CABLE_NUMBER $APP_DIR/$ELF_NAME"
#
# In the multiprocessor_tutorial HW design, Quartus II and Qsys happen to assign
# Philosopher cpu instance and philosopher jtag_uart instances set 
# to 1 higher than the philosopher number. 

cmd="nios2-download -g -r --jdi $SOPC_DIR/$JDI_FILE --cpu_name $PHILOSOPHER_DOWNLOAD_CPU_NAME --cable $CABLE_NUMBER $APP_DIR/$ELF_NAME"
echo "Executing" $cmd
$cmd || {
    echo "failed to download the software .elf file"
    exit 1
}

# Opening terminal connection
cmd="nios2-terminal --cable=$CABLE_NUMBER --instance=$JTAG_UART_INSTANCE_NUMBER"
echo "Executing" $cmd
$cmd || {
    echo "failed to open the Nios II terminal"
    exit 1
}

#*******************************************************************************
#*                                                                             *
#* License Agreement                                                           *
#*                                                                             *
#* Copyright (c) 2011 Altera Corporation, San Jose, California, USA.           *
#* All rights reserved.                                                        *
#*                                                                             *
#* Permission is hereby granted, free of charge, to any person obtaining a     *
#* copy of this software and associated documentation files (the "Software"),  *
#* to deal in the Software without restriction, including without limitation   *
#* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
#* and/or sell copies of the Software, and to permit persons to whom the       *
#* Software is furnished to do so, subject to the following conditions:        *
#*                                                                             *
#* The above copyright notice and this permission notice shall be included in  *
#* all copies or substantial portions of the Software.                         *
#*                                                                             *
#* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
#* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
#* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
#* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
#* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
#* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
#* DEALINGS IN THE SOFTWARE.                                                   *
#*                                                                             *
#* This agreement shall be governed in all respects by the laws of the State   *
#* of California and by the laws of the United States of America.              *
#* Altera does not recommend, suggest or require that this reference design    *
#* file be used in conjunction or combination with any other product.          *
#*******************************************************************************

