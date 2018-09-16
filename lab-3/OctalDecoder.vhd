-----------------------------------------------------------
-- File name: OctalDecoder.vhd
-- Designer name: Matthew Cather
-- Date created: 9/16/18
--
-- Design description:
-- Converts a 3-bit binary number to seven-segment code
-- to drive a 7-segment display.
-----------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OctalDecoder is
    port (D        : in  STD_LOGIC_VECTOR (2 downto 0);
          Segments : out  STD_LOGIC_VECTOR (6 downto 0));
end OctalDecoder;

architecture Behavioral of OctalDecoder is

begin

process(D)
begin
case D is
  when "000" => --ABCDEFG
    Segments <=  "0000001"; -- 0
  when "001" =>
    Segments <=  "1001111"; -- 1
  when "010" =>
    Segments <=  "0010010"; -- 2
  when "011" =>
    Segments <=  "0000110"; -- 3
  when "100" =>
    Segments <=  "1001100"; -- 4
  when "101" =>
    Segments <=  "0100100"; -- 5
  when "110" =>
    Segments <=  "0100000"; -- 6
  when "111" =>
    Segments <=  "0001111"; -- 7
  when others =>
    Segments <=  "1111111"; -- all off
  end case;
end process;

end Behavioral;
