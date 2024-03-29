library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.all;

entity Lab_6_TOP is
  Generic (M : integer := 2;
           N : integer := 4);
  Port (PB : in std_logic;
        r_addr: in std_logic_vector(M-1 downto 0);
        w_addr : in std_logic_vector(M-1 downto 0);
        di : in std_logic_vector(N-1 downto 0);
        do : out std_logic_vector(N-1 downto 0);
        CLK: in std_logic);
end entity Lab_6_TOP;

architecture Hierarchy of Lab_6_TOP is
	signal PBdb, EN: STD_LOGIC;

	begin

	DB: entity WORK.Debounce port map
			(CLK=>CLK, PB=>PB, PBdb=>PBdb);

	One_Shot: entity  WORK.One_Shot_Timer port map
			(CLK=>CLK, PB=>PBdb, EN=>EN);

	memory: entity  WORK.Memory generic map (M,N) port map
			(WE=>EN, r_addr=>r_addr, w_addr=>w_addr, di=>di, do=>do);
end architecture Hierarchy;
