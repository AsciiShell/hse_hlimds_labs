#     vsim -c -do run.do

onerror {resume}
# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the HDL source(s)
vlog -sv -dpiheader extra.h extra_test.v extra.c

# Simulate the design
onerror {quit -sim}
vsim -c -voptargs="+acc=rn" extra_test
onbreak {resume}

# log signals in database
log -r *
add wave /extra_test/arr
add wave /extra_test/do_convert


# run simulation
run -all
# quit -f
