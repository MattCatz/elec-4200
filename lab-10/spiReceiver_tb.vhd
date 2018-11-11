Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.txt_util.all;

entity Lab_10_TOP_tb is
end entity Lab_10_TOP_tb;

architecture testbench of Lab_10_TOP_TB is
    constant half_period : TIME := 5 ns;
    
    signal MOSI,SCK,ACK,CLK,RDY,RST: std_logic := '0';

    signal OUTPUT: std_logic_vector(5 downto 0);
    
    signal FIN : std_logic := '0';

	begin
	receiver : entity WORK.spi_receiver port map(MOSI=>MOSI,SCK=>SCK,ACK=>ACK,CLK=>CLK,RDY=>RDY,OUTPUT=>OUTPUT,RST=>RST);

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
			RST,MOSI,SCK,ACK,RDY : STD_LOGIC;	
			Q : Integer;
		end record;

		type test_vector_array is array (natural range <>) of test_vector;
		constant test_vectors : test_vector_array := (
		--  RST MOSI, SCK, ACK, RDY    Q
			('1', '0', '0', '0', '0',  0), -- Inital State
			('0', '1', '1', '0', '0',  0), -- Send one
			('0', '1', '1', '0', '0',  0), -- Send one
			('0', '0', '1', '0', '0',  0), -- Send zero
			('0', '1', '1', '0', '0',  0), -- Send one
			('0', '0', '1', '0', '0',  0), -- Send zero
			('0', '0', '1', '0', '1', 11), -- Send zero and expect the results to be ready
			('0', '0', '0', '1', '0', 11), -- Acknowledge the results
			('0', '0', '1', '0', '0', 11), -- Send zero
			('0', '0', '1', '0', '0', 11), -- Send zero
			('0', '0', '1', '0', '0', 11), -- Send zero
			('0', '0', '1', '0', '0', 11), -- Send zero
			('0', '0', '1', '0', '0', 11), -- Send zero
			('0', '0', '1', '0', '1',  0), -- Send zero and expect the results to be ready
			('0', '1', '0', '0', '0',  0), -- Signal but dont send
			('0', '1', '0', '0', '0',  0), -- Signal but dont send
			('0', '1', '0', '0', '0',  0), -- Signal but dont send
			('0', '1', '0', '0', '0',  0), -- Signal but dont send
			('0', '1', '0', '0', '0',  0), -- Signal but dont send
			('0', '1', '0', '0', '0',  0), -- Signal but dont send
			('0', '0', '0', '0', '0',  0), -- Expect no results
			('1', '1', '1', '0', '0',  0), -- Send one
			('1', '1', '1', '0', '0',  0), -- Send one
			('1', '1', '1', '0', '0',  0), -- Send one
			('1', '1', '1', '0', '0',  0), -- Send one
			('1', '1', '1', '0', '0',  0), -- Send one
      ('0', '1', '1', '1', '0', 63)); -- Send one and Acknowledge early
		begin
			report "Starting Tests" severity note;
			for i in test_vectors'range loop
			  RST <= test_vectors(i).RST;
				MOSI <= test_vectors(i).MOSI;
				SCK <= test_vectors(i).SCK;
				ACK <= test_vectors(i).ACK;
				wait until rising_edge(CLK);
				wait for 1 ns; -- Wait for signals to change
				assert RDY = test_vectors(i).RDY
				    report "Failed loop " & str(i) & " RDY:" & str(test_vectors(i).RDY) & " Got:" & str(RDY);
				assert OUTPUT = STD_LOGIC_VECTOR(to_unsigned(test_vectors(i).Q, OUTPUT'length)) 
					report "Failed loop " & str(i) & " OUTPUT:" & str(test_vectors(i).Q) & " Got:" & str(OUTPUT);
			end loop;
			report "End of tests" severity note;
			FIN <= '1';
			wait;
	end process;
 
end architecture testbench;
