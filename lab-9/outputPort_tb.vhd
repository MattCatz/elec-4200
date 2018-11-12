Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.txt_util.all;

entity output_port_tb is
end entity output_port_tb;

architecture testbench of output_port_tb is

constant half_period : TIME := 5 ns;
constant port_size: Natural := 11;
signal input,output : STD_LOGIC_VECTOR(port_size-1 downto 0);

signal enable,strobe,CLK,FIN : STD_LOGIC := '0';

begin
    output_port: entity WORK.output_port generic map(port_size) port map(clk=>CLK, output=>output, input=>input, enable=>enable, strobe=>strobe);

	test_clk : process (CLK)
	begin
		if FIN = '0' then
			CLK <= not CLK after half_period;
		else
			CLK <= '0';
		end if;
	end process test_clk;

	process
		type test_vector is record
			enable,strobe : STD_LOGIC;	
			input,output : Integer;
		end record;

		type test_vector_array is array (natural range <>) of test_vector;
		constant test_vectors : test_vector_array := (
		--  enable
			('0', '0',   0,  0), -- Inital State
            ('1', '1',   5,  5),
            ('0', '0',   0,  5), -- Check load
            ('1', '0', 100,  5),
            ('0', '0',   0,  5), -- Check not loaded
            ('0', '1', 100,  5),
            ('0', '0',   0,  5), -- Check not loaded
            ('1', '0', 127,  5),
            ('1', '1', 127,127),
            ('0', '0', 127,127));
		begin
			report "Starting Tests" severity note;
			for i in test_vectors'range loop
				enable <= test_vectors(i).enable;
				strobe <= test_vectors(i).strobe;
				input <= STD_LOGIC_VECTOR(to_unsigned(test_vectors(i).input, input'length));
				wait until rising_edge(CLK);
				wait for 1 ns; -- Wait for signals to change
				assert output = STD_LOGIC_VECTOR(to_unsigned(test_vectors(i).output, output'length)) 
					report "Failed loop " & str(i) & " OUTPUT:" & str(test_vectors(i).output) & " Got:" & str(OUTPUT);
			end loop;
			report "End of tests" severity note;
			FIN <= '1';
			wait;
	end process;
end architecture;
