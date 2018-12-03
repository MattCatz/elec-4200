Library IEEE;
use IEEE.std_logic_1164.all;

entity spi_receiver is
port(MOSI,SCK,ACK,CLK: in std_logic;
     RDY: out std_logic;
     OUTPUT: out std_logic_vector(5 downto 0));
end entity spi_receiver;

architecture lab_nine of spi_receiver is
	type state_type is (ready,not_ready); 
	signal current_state, next_state : state_type;
	
	shared variable count : Natural := 0;

    signal RDY_i,RDY_L : std_logic := '0';
	signal Q,Q_RDY: STD_LOGIC_VECTOR(5 downto 0) := (others => '0');

begin
				
	SYNC: process(CLK,SCK)
    begin
        if rising_edge(clk) then
            if SCK = '1' then
               count := count + 1;
                if count = 6 then
                    count := 0;
                    Q_RDY <= MOSI & Q(5 downto 1);
                    RDY_i <= '1';
                else
                    Q_RDY <= Q_RDY;
                end if;
                Q <= MOSI & Q(4 downto 0);
            else
                RDY_i <= '0';
            end if;
        end if;
    end process SYNC;
   
   OUTPUT <= Q_RDY;
   RDY <= RDY_L;
   
	FF :  process(CLK,RDY_i,ACK)
    begin
        if rising_edge(CLK) then
            if ACK = '1' then
                RDY_L <= '0';
            elsif RDY_i = '1' then
                RDY_L <= '1';
            end if;
        end if;
    end process FF;

end architecture lab_nine;
