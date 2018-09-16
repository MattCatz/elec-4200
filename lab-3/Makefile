.RECIPEPREFIX = >
.PHONY: test test_octal test_hex clean
.TARGET: test

files = OctalDecoder.vhd OctalDecoder_tb.vhd HexDecoder.vhd HexDecoder_tb.vhd textutils.vhd 

test : test_octal test_hex

test_octal: work-obj93.cf
> ghdl -m OctalDecoder_tb                                                                                                                                                 
> ghdl -r OctalDecoder_tb

test_hex: work-obj93.cf 
> ghdl -m OctalDecoder_tb                                                                                                                                                 
> ghdl -r OctalDecoder_tb

work-obj93.cf: $(files)
> ghdl -i $(files)

clean:
> rm work-obj93.cf
