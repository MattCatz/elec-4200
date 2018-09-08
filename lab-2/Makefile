.RECIPEPREFIX = >
.PHONY: test

test : work-obj93.cf
> ghdl -m ring_counter_tb
> ghdl -r ring_counter_tb 

work-obj93.cf : lab2.vhd ring_counter_tb.vhd
> ghdl -i lab2.vhd
> ghdl -i ring_counter_tb.vhd
> ghdl -i textutils.vhd 
