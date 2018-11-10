Library IEEE;
use IEEE.std_logic_1164.all;

entity spi_receiver is
port(MOSI,SCK,ACK,CLK: in std_logic;
     RDY_L: out std_logic;
     OUTPUT: out std_logic_vector(5 downto 0));
end entity spi_receiver;

architecture lab_nine of spi_receiver is
	type state_type is (S0,S1,S2,S3,S4,S5); 
	signal current_state, next_state : state_type;

    signal RDY : std_logic := '0';
	signal PBdb : std_logic := '0';
	signal EN : std_logic := '0';
	signal Q,Q_RDY: STD_LOGIC_VECTOR(5 downto 0) := (others => '0');

begin
	
	DB: entity WORK.Debounce port map(CLK=>CLK, PB=>SCK, PBdb=>PBdb);
	One_Shot: entity  WORK.One_Shot_Timer port map(CLK=>CLK, PB=>PBdb, EN=>EN);
				
	SYNC: process(CLK,PBdb)
    begin
        if rising_edge(clk) then
            if EN = '1' then
                current_state <= next_state;
                Q <= Q(4 downto 0) & MOSI;
            end if;
        end if;
    end process SYNC;
    
    with current_state select
        next_state <= S1 when S0,
                      S2 when S1,
                      S3 when S2,
                      S4 when S3,
                      S5 when S4,
                      S0 when others;
                      
    with current_state select
        RDY <= '1' when S5,
               '0' when others;
               
    with current_state select
        Q_RDY <= Q when S0,
                 Q_RDY when others;   
   
   OUTPUT <= Q_RDY;
   
	FF :  process(CLK,RDY,ACK)
    begin
        if rising_edge(CLK) then
            if ACK = '1' then
                RDY_L <= '0';
            elsif RDY = '1' then
                RDY_L <= '1';
            end if;
        end if;
    end process FF;

end architecture lab_nine;
