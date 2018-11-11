Library IEEE;
use IEEE.std_logic_1164.all;

entity lab_10_heiarchy is
port(MOSI,PB,ACK,CLK: in std_logic;
     RDY: out std_logic;
     OUTPUT: out std_logic_vector(5 downto 0));
end entity lab_10_heiarchy;

architecture lab_nine of lab_10_heiarchy is
	signal PBdb : std_logic := '0';
	signal EN : std_logic := '0';

begin
	
	DB: entity WORK.Debounce port map(CLK=>CLK, PB=>PB, PBdb=>PBdb);
	One_Shot: entity  WORK.One_Shot_Timer port map(CLK=>CLK, PB=>PBdb, EN=>EN);
	reciver: entity WORK.spi_receiver port map(MOSI=>MOSI,SCK=>EN,ACK=>ACK,CLK=>CLK,RDY=>RDY,OUTPUT=>OUTPUT,RST=>'0');

end architecture lab_nine;
