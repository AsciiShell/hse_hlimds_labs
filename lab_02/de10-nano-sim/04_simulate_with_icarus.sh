#!/bin/bash

rm -rf sim
mkdir sim
cd sim

cp ../../de10-nano/*.hex .

# default simulation params
SIMULATION_CYCLESS=120

# read local simulation params
source ../icarus.cfg

# compile
iverilog -g2005 -D SIMULATION -D ICARUS -I ../ -I ../../de10-nano -s sm_testbench ../*.v ../../de10-nano/*.v

# simulation
vvp -la.lst -n a.out -vcd

# output
gtkwave dump.vcd

cd ..
