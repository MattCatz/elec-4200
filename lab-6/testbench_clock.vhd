Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench_clock is
  Generic (half_period : Time := 5 ns);
  Port (ENABLE : in STD_LOGIC,
        CLK : out STD_LOGIC);
end entity testbench_clock;

architecture simple_clock of testbench_clock is

	process (ENABLE, CLK)
	begin
		if ENABLE = '1' then
			CLK <= not CLK after half_period;
		else
			CLK <= '0';
		end if;
	end process;

end architecture simple_clock;