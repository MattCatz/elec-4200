Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.txt_util.all;

entity Lab_5_TOP_tb is
end entity Lab_5_TOP_tb;

architecture testbench of Lab_5_TOP_TB is
	component Shift_Register is
		Generic (N : Integer := 8);
		Port( CLK, RST, CE, M1, M0: in STD_LOGIC;
			  	DIN: in STD_LOGIC_VECTOR(N-1 downto 0);
					QOUT: out STD_LOGIC_VECTOR(N-1 downto 0));
	end component Shift_Register;
	
	constant half_period : TIME := 5 ns;
	constant register_size : INTEGER := 8;
	signal FIN,CLK, RST, CE, M1, M0: STD_LOGIC := '0';
	signal D, Q: STD_LOGIC_VECTOR(register_size-1 downto 0); 

	begin
		lab_5: Shift_Register generic map (register_size)
					 port map (CLK=>CLK, RST=>RST, CE=>CE, M1=>M1, M0=>M0, QOUT=>Q, DIN=>D);

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
			RST,CE,M1,M0 : STD_LOGIC;	
			D,Q : Integer;
		end record;

		type test_vector_array is array (natural range <>) of test_vector;
		constant test_vectors : test_vector_array := (
		--RST   CE   M1   M0   D  Q
			('0', '0', '0', '0', 0, 0),
			('1', '1', '1', '1', 0, 0),
			('0', '1', '1', '0', 0, 1),
			('0', '1', '1', '0', 0, 2),
			('0', '1', '1', '0', 0, 3),
			('0', '1', '1', '0', 0, 4),
			('0', '1', '0', '1', 0, 8),
			('0', '1', '0', '1', 0, 16),
			('0', '1', '1', '1', 253, 253),
			('0', '1', '1', '0', 0, 254),
			('0', '1', '1', '0', 0, 255),
			('0', '1', '1', '0', 0, 0),
			('0', '1', '1', '1', 19, 19),
			('1', '1', '1', '1', 0, 0));
		begin
			report "Starting Tests" severity note;
			for i in test_vectors'range loop
				report "Vector: " & str(i);
				RST <= test_vectors(i).RST;
				CE <= test_vectors(i).CE;
				M1 <= test_vectors(i).M1;
				M0 <= test_vectors(i).M0;
				D <= STD_LOGIC_VECTOR(to_unsigned(test_vectors(i).D, D'length));
				wait until rising_edge(CLK);
				wait for 1 ns;
				CE <= '0';
				wait until rising_edge(CLK);
				wait for 1 ns;
				assert Q = STD_LOGIC_VECTOR(to_unsigned(test_vectors(i).Q, Q'length)) 
					report "Failed Q:" & str(test_vectors(i).Q) & " Got:" & str(Q);
			end loop;
			report "End of tests" severity note;
			FIN <= '1';
			wait;
	end process;
 
end architecture testbench;
