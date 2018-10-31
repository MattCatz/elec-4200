library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_port is
    port(input : in STD_LOGIC_VECTOR(3 downto 0);
         output : out STD_LOGIC_VECTOR(3 downto 0);
         pb : in STD_LOGIC;
         sel : in STD_LOGIC;
         clk    : in STD_LOGIC);
end entity;

architecture behavior of input_port is
    signal Q : STD_LOGIC_VECTOR(3 downto 0);
    
    begin
    
    output <= Q;
    
    process(clk,pb,sel)
    begin
    if rising_edge(clk) then
        if (sel='0') then
            Q <= input;
        elsif (sel='1') then
            Q(0) <= pb;
            Q(3 downto 1) <= (others => '0');
        end if;
    end if;
    end process;
end behavior;
