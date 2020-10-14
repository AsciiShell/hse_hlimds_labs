
vlib work

set p0 -vlog01compat
set p1 +define+SIMULATION

set i0 +incdir+../
set i1 +incdir+../../de10-nano

set s0 ../*.v
set s1 ../../de10-nano/*.v

vlog $p0 $p1  $i0 $i1  $s0 $s1

vsim work.sm_testbench

add wave -radix hex sim:/sm_testbench/x
add wave -radix hex sim:/sm_testbench/predict

run -all

wave zoom full
