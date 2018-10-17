library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity One_Shot_Timer is
	port (CLK, PB: in STD_LOGIC;
				EN: out STD_LOGIC);
end One_Shot_Timer;

architecture three_stage of One_Shot_Timer is 
	signal X,Y,Z: STD_LOGIC;

	begin
	-- First D flip-flop of the one-shot circuit
	ONESHOTFF1 : process (CLK)
  	begin
    	if rising_edge(CLK) then  -- trigger on rising clock edge
      	X <= PB;                -- PB = D-input, X = Q-output
    	end if;
  	end process;

	-- Second D flip-flop of the one-shot circuit
	ONESHOTFF2 : process (CLK)
  	begin
    	if rising_edge(CLK) then  -- trigger on rising clock edge
      	Y <= X;                 -- X = D-input, Y = Q-output
    	end if;
  	end process;

	-- Third D flip-flop of the one-shot circuit
	ONESHOTFF3 : process (CLK)
  	begin
    	if rising_edge(CLK) then  -- trigger on rising clock edge
      	Z <= Y;                 -- Y = D-input, Z = Q-output
    	end if;
  	end process;

	--Create enable signal with the output of the oneshot
	EN <= Y and not Z;
end three_stage;
