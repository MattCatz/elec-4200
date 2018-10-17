.RECIPEPREFIX = >
.PHONY: all

files = OctalDecoder.vhd OctalDecoder_tb.vhd HexDecoder.vhd HexDecoder_tb.vhd ../textutils.vhd

testbenches = OctalDecoder_tb  HexDecoder_tb

all: test

test_octal: work-obj93.cf
> ghdl -m OctalDecoder_tb
> ghdl -r OctalDecoder_tb

test_hex: work-obj93.cf
> ghdl -m HexDecoder_tb
> ghdl -r HexDecoder_tb

include ../Default.mk
