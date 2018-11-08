Library IEEE;
use IEEE.std_logic_1164.all;

entity spi_receiver is
generic (N : Natural := 6);
port(MOSI,SCK,ACK,CLK: in std_logic;
     RDY_L: out std_logic;
     OUTPUT: out std_logic_vector(N-1 downto 0));
end entity spi_receiver;

architecture lab_nine of spi_receiver is
	type state_type is (s_idle, s_running, s_done); 
	signal current_state, next_state : state_type;
	shared variable counter : Natural := 0;

    signal RDY : std_logic := '0';
	signal shift_in : std_logic := '0';
	signal en_shift,en_data : std_logic := '0';
	signal data_1,data_2 : std_logic_vector(N-1 downto 0) := (others => '0');
	signal PBdb : std_logic := '0';

begin

	data_1(N-1) <= shift_in;
	OUTPUT <= data_2;
	
	DB: entity WORK.Debounce port map(CLK=>CLK, PB=>SCK, PBdb=>PBdb);

	reg_shift: entity WORK.Shift_Register 
				generic map(N)
				port map(CLK=>CLK, RST=>'0', CE=>en_shift, M1=>'0', M0=>'1', QOUT=>data_2, DIN=>data_1);

	reg_data: entity WORK.Shift_Register 
				generic map(N)
				port map(CLK=>CLK, RST=>'0', CE=>en_data, M1=>'1', M0=>'1', DIN=>data_2);
				
		SYNC: process(clk)
                begin
                    if rising_edge(clk) then
                        current_state <= next_state;
                    end if;
            end process SYNC;

	CONTROLLER: process(CLK)
	begin
		en_data <= '0';
        en_shift <= '0';
        RDY <= '0';
		case current_state is
			when s_running => 
			     shift_in <= MOSI;
			     en_shift <= '1';
			when s_done =>
				en_data <= '1';
				RDY <= '1';
			when s_idle =>
		end case;
	end process CONTROLLER;
	
	FF :  process(RDY,ACK)
    begin
        if ACK = '1' then
            RDY_L <= '0';
        elsif RDY = '1' then
            RDY_L <= '1';
        end if;
    end process FF;

	DECODE_NEXT: process(current_state,PBdb)
	begin
		next_state <= s_idle;
		if (current_state = s_idle) and (PBdb='1') then
		  next_state <= s_running;
		elsif (current_state = s_running) then
			if counter = N then
				next_state <= s_done;
				counter := 0;
			end if;
			counter := counter + 1;
			next_state <= s_idle;
		end if;
	end process DECODE_NEXT;
end architecture lab_nine;
