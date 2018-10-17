library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.all;

entity Lab_7_TOP is
  Generic (M : Natural := 2;
           N : Natural := 4;
           K : Natural := 15);
  Port (PB : in std_logic;
        W_ADDR : in std_logic_vector(M-1 downto 0);
        INPUT_DATA : in std_logic_vector(N-1 downto 0);
        SEGMENTS : out std_logic_vector(6 downto 0);
        DISPLAY_ENABLE: out std_logic_vector(3 downto 0);
        CLK: in std_logic);
end entity Lab_7_TOP;

architecture Hierarchy of Lab_7_TOP is
	signal PBdb, EN: STD_LOGIC;
	signal OUTPUT_DATA : std_logic_vector(N-1 downto 0);
	signal count : std_logic_vector(K-1 downto 0);
	signal r_addr: std_logic_vector(M-1 downto 0);

	begin

	DB: entity WORK.Debounce port map
			(CLK=>CLK, PB=>PB, PBdb=>PBdb);

	One_Shot: entity  WORK.One_Shot_Timer port map
			(CLK=>CLK, PB=>PBdb, EN=>EN);

	memory: entity  WORK.Memory generic map (M,N) port map
			(WE=>EN, r_addr=>r_addr, w_addr=>w_addr, DI=>INPUT_DATA, DO=>OUTPUT_DATA);

	display: entity WORK.HexDecoder port map (D=>OUTPUT_DATA, segments=>segments);

	fsm: entity WORK.Moore_FSM_Equations_FD port map
	     (CLK=>CLK, RST=>'0', PB=>count(K-1), Cold_out=>DISPLAY_ENABLE, Binary_out=>r_addr);

	counter: entity WORK.Shift_Register generic map (K) port map
	         (CLK=>CLK, Din=>(others => '0'), M1=>'1', M0=>'0', CE=>'1', RST=>'0', QOUT=>count);
end architecture Hierarchy;
