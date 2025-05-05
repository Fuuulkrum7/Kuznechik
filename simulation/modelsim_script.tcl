vlib work

vlog ../testbench.v ../../crypto.v ../../helpers.v ../../cipher.v ../../keygen.v ../../Lut.v

vsim work.testbench

add wave sim:/testbench/*

run -all

wave zoom full
