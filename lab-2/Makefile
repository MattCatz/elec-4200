.RECIPEPREFIX = >
.PHONY: test

test : work-obj93.cf
> ghdl -m Moore_FSM_Equations_FD_tb
> ghdl -r Moore_FSM_Equations_FD_tb 

work-obj93.cf : Moore_FSM_Equations_FD.vhd Moore_FSM_Equations_FD_tb.vhd
> ghdl -i Moore_FSM_Equations_FD.vhd
> ghdl -i Moore_FSM_Equations_FD_tb.vhd
> ghdl -i textutils.vhd 
