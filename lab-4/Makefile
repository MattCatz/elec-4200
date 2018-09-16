.RECIPEPREFIX = >
.PHONY: test

files = Moore_FSM_Equations_FD.vhd Moore_FSM_Equations_FD_tb.vhd textutils.vhd

test : work-obj93.cf
> ghdl -m Moore_FSM_Equations_FD_tb
> ghdl -r Moore_FSM_Equations_FD_tb 

work-obj93.cf : $(files)
> ghdl -i $(files)

clean:
> rm work-obj93.cf 
