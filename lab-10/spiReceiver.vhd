Library IEEE;
use IEEE.std_logic_1164.all;

entity spi_receiver is
generic (N : Natural := 6);
port(MOSI,SCK,ACK,SEL,EN,CLK: in std_logic;
     RDY: out std_logic;
     OUTPUT: out std_logic_vector(N-1 downto 0));
end entity spi_receiver;

architecture lab_nine of spi_receiver is
	type state_type is (s_running, s_done); 
	signal current_state, next_state : state_type;
	shared variable counter : Natural := 0;

	signal shift_in : std_logic := '0';
	signal en_shift,en_data : std_logic := '0';
	signal data_1,data_2 : std_logic_vector(N-1 downto 0);

begin

	data_1(N-1) <= shift_in;

	reg_shift: entity WORK.Shift_Register 
				generic map(N)
				port map(CLK=>CLK, RST=>'0', CE=>en_shift, M1=>'0', M0=>'1', QOUT=>data_2, DIN=>data_1);

	reg_data: entity WORK.Shift_Register 
				generic map(N)
				port map(CLK=>CLK, RST=>'0', CE=>en_data, M1=>'1', M0=>'1', QOUT=>OUTPUT, DIN=>data_2);

	SYNC: process(clk)
	begin
		if rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process SYNC;

	CONTROLLER: process(current_state)
	begin
		en_data <= '0';
		en_shift <= '0';
		RDY <= '0';
		case current_state is
			when s_running => shift_in <= MOSI;
			when s_done =>
				en_data <= '1';
				RDY <= '1';
		end case;
	end process CONTROLLER;

	DECODE_NEXT: process(current_state, SCK, ACK)
	begin
		next_state <= s_running;
		case current_state is 
			when s_running =>
				if (current_state = s_running) and (SCK='1') then
					counter := counter + 1;
					if counter = N then
						next_state <= s_done;
						counter := 0;
					end if;
				end if;
			when s_done =>
				next_state <= s_done;
				if ACK = '1' then
					next_state <= s_running;
				end if;
			end case;
	end process DECODE_NEXT;
end architecture lab_nine;
