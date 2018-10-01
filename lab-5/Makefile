.RECIPEPREFIX = >
.PHONY: test

files = Lab_5_tb.vhd main.vhd debounce.vhd one-shot.vhd shift-register.vhd ../textutils.vhd 

test : work-obj93.cf
> ghdl -m Lab_5_TOP_tb 
> ghdl -r Lab_5_TOP_tb 

work-obj93.cf : $(files)
> ghdl -i $(files)

clean:
> rm work-obj93.cf 
