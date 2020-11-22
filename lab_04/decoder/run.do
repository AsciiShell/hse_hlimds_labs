#     vsim -c -do run.do

onerror {resume}
# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the HDL source(s)
vlog -sv -dpiheader decoder.h decoder17_test.v decoder.c

# Simulate the design
onerror {quit -sim}
vsim -c -voptargs="+acc=rn" decoder17_test
onbreak {resume}

# log signals in database
log -r *
add wave -divider "INPUTS"
add wave /decoder17_test/src
add wave -divider "OUTPUTS"
add wave /decoder17_test/out

# run simulation
run -all
quit -f