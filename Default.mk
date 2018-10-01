.RECIPEPREFIX = >
.PHONY: test clean

%_tb:
> ghdl -m $@
> ghdl -r $@


test : work-obj93.cf $(testbenches)

work-obj93.cf : $(files)
> ghdl -i $(files)

clean:
> rm work-obj93.cf 
