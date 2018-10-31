library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity output_port is
    generic(N: natural :=8);
    port(input : in STD_LOGIC_VECTOR(N-1 downto 0);
         output : out STD_LOGIC_VECTOR(N-1 downto 0);
         enable : in STD_LOGIC;
         strobe : in STD_LOGIC;
         clk    : in STD_LOGIC);
end entity;

architecture behavior of output_port is
    signal Q : STD_LOGIC_VECTOR(N-1 downto 0);
    
    begin
    
    output <= Q;
    
    process(clk,enable,strobe)
    begin
    if rising_edge(clk) then
        if (enable='1' AND strobe='1') then
            Q <= input;
        end if;
    end if;
    end process;
end behavior;
