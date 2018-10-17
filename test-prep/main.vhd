library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_1 is
port(A, B, C: in STD_LOGIC;
     Q : out STD_LOGIC);
end test_1;

architecture behav of test_1 is
signal Q_i: STD_LOGIC_VECTOR(2 downto 0);
begin
Q_i <= A & B & C;

with Q_i select
  Q <= '1' when "000",
       '1' when "010",
       '0' when others;

if (Q_i = "100") then Q <= '1';

end behav;
