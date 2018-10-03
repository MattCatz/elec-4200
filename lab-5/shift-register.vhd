library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Shift_Register is
	Generic (N : integer := 8); 
	Port (DIN: in STD_LOGIC_VECTOR(N-1 downto 0);
				CE,M1,M0,RST,CLK: in STD_LOGIC;
				QOUT: out STD_LOGIC_VECTOR(N-1 downto 0));
end Shift_Register;

architecture lab_5 of Shift_Register is
	signal Q: STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
	signal state: STD_LOGIC_VECTOR(1 downto 0);
	
	begin

	state(1) <= M1;
	state(0) <= M0;
	QOUT <= Q;
	
	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				Q <= (others => '0');
			elsif CE = '1' then
				case state is
					when "00" =>
						Q <= Q;
					when "01" =>
						Q <= D(N-1) & Q(N-1 downto 1);
					when "10" =>
						Q <= STD_LOGIC_VECTOR(unsigned(Q) + 1);
					when "11" =>
						Q <= DIN;
					when others =>
						Q <= (others => 'X');
			end case;
			else 
				Q <= Q;
			end if;
		end if;
	end process;
end lab_5;
