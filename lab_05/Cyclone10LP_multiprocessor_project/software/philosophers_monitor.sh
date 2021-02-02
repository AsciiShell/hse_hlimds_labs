#!/bin/sh
# AUTHOR:       soreilly
# DATA:         05/13/2011
# DESCRIPTION:  A script that contains a bunch of app and bsp switches that will generate 
#		the makefiles, compile the code, download the code, open a terminal.
#               Pass in a cable number if you have multiple jtag programming cables.
#
# 		Usage:    ./philosophers_monitor <optional cable number>
#               Example:  ./philosophers_monitor 2
#
#               Tip: Type 'jtagconfig -n' to list all the jtag cables connected 
#		to the host (or remote cables).

# These are the two folders where all the files are dumped
APP_DIR=./app_monitor
BSP_DIR=./bsp_monitor
SRC_DIR=./philosophers_monitor_src

SOPC_DIR=..
OPTIMIZATION_LEVEL="-O2"
MEMORY_NAME=onchip_memory
SIMULATION_OPTIMIZED_SUPPORT="false"
BSP_TYPE=hal
BSP_FLAGS="--set hal.max_file_descriptors 4 \
--cpu-name cpu_top \
--set hal.stdin jtag_uart_top \
--set hal.stdout jtag_uart_top \
--set hal.stderr jtag_uart_top \
--set hal.sys_clk_timer none \
--set hal.timestamp_timer none \
--set hal.enable_exit true \
--set hal.enable_reduced_device_drivers true \
--set hal.enable_lightweight_device_driver_api true \
--set hal.enable_small_c_library true \
--set hal.enable_c_plus_plus false \
--set hal.enable_clean_exit true \
--set hal.enable_sim_optimize $SIMULATION_OPTIMIZED_SUPPORT \
--set hal.make.bsp_cflags_optimization $OPTIMIZATION_LEVEL \
--default_sections_mapping $MEMORY_NAME"

# Name of the elf file
ELF_NAME=philosophers_monitor.elf
# JDI file name
#JDI_FILE=multiprocessor_tutorial.jdi
JDI_FILE=top.jdi

# Check the number of arguments passed into the script
if [ $# -ne 1 ]
then
    CABLE_NUMBER="1"
else
  	CABLE_NUMBER=$1
	echo "Cable number is " $CABLE_NUMBER
fi


# In the multiprocessor_tutorial HW design, Quartus II & Qsys happen to assign 
# cpu_top as cpu instance 0, and jtag_uart_top as jtag_uart instance 0
JTAG_UART_INSTANCE_NUMBER=0
PHILOSOPHER_DOWNLOAD_CPU_NAME="cpu_top"

# ************ DON'T NEED TO MODIFY ANYTHING BELOW THIS LINE ***************

# make sure the application and bsp directories are blown away first 
# before attempting to regenerate new projects
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

# In the multiprocessor_tutorial HW design, Quartus II & Qsys
# happen to assign cpu_top as cpu instance 0, and
# jtag_uart_top as jtag_uart instance 0. 
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


