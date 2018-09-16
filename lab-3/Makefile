.RECIPEPREFIX = >
.PHONY: test

test : work-obj93.cf
> ghdl -m OctalDecoder_tb
> ghdl -r OctalDecoder_tb

work-obj93.cf :
> ghdl -i OctalDecoder.vhd
> ghdl -i OctalDecoder_tb.vhd
> ghdl -i textutils.vhd
