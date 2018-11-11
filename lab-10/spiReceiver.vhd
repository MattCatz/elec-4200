Library IEEE;
use IEEE.std_logic_1164.all;

entity spi_receiver is
port(MOSI,SCK,ACK,CLK,RST: in std_logic;
     RDY: out std_logic;
     OUTPUT: out std_logic_vector(5 downto 0));
end entity spi_receiver;

architecture lab_nine of spi_receiver is
	type state_type is (S0,S1,S2,S3,S4,S5); 
	signal current_state, next_state : state_type;

    signal RDY_i,RDY_L : std_logic := '0';
	signal Q,Q_RDY: STD_LOGIC_VECTOR(5 downto 0) := (others => '0');

begin
				
	SYNC: process(CLK,SCK,RST)
    begin
        if rising_edge(clk) then
            if SCK = '1' then
                current_state <= next_state;
                Q <= MOSI & Q(4 downto 0);
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
                 
    process (Q)
    begin
        case current_state is
            when S5 => 
                Q_RDY <= Q;
                RDY_i <= '1';
            when others =>
                Q_RDY <= Q_RDY;
                RDY_i <= '0';
            end case;
    end process; 
   
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
