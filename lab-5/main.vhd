library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lab_5_TOP is
	Generic (N : Integer := 8);
	Port( CLK, PB, RST, M1, M0: in STD_LOGIC;
			  D: in STD_LOGIC_VECTOR(N-1 downto 0);
				Q: out STD_LOGIC_VECTOR(N-1 downto 0));
end entity Lab_5_TOP;

architecture Hierarchy of Lab_5_TOP is
	signal PBdb, EN: STD_LOGIC;

	component Debounce is
	Generic(N : integer := 8);
	Port(
			PB : in STD_LOGIC;		--Signal to debounce
			CLK : in STD_LOGIC;		--Clock
			PBdb : out STD_LOGIC);	--debounced signal
	end component Debounce;

	component One_Shot_Timer is
	Port (CLK, PB: in STD_LOGIC;
				EN: out STD_LOGIC);
	end component One_Shot_Timer;

	component Shift_Register is
	Generic(N: integer := 8);
	Port (DIN: in STD_LOGIC_VECTOR(N-1 downto 0);
				CE,M1,M0,RST,CLK: in STD_LOGIC;
				QOUT: out STD_LOGIC_VECTOR(N-1 downto 0));
	end component Shift_Register;

	begin

	DB: Debounce generic map (6) port map
			(CLK=>CLK, PB=>PB, PBdb=>PBdb);

	One_Shot: One_Shot_Timer port map
			(CLK=>CLK, PB=>PBdb, EN=>EN);

	SC_8_Bit: Shift_Register generic map (8) port map
			(CLK=>CLK, RST=>RST, CE=>EN, M1=>M1, M0=>M0, QOUT=>Q, DIN=>D);
end architecture Hierarchy;
