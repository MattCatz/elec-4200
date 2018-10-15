library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity Memory is
  Generic (M : Natural := 8;
           N : Natural := 8);
  Port (we : in std_logic;
        r_addr: in std_logic_vector(M-1 downto 0);
        w_addr : in std_logic_vector(M-1 downto 0);
        di : in std_logic_vector(N-1 downto 0);
        do : out std_logic_vector(N-1 downto 0));
end entity Memory;

architecture lab_6 of Memory is
  type ram_type is array (2**M downto 0) of std_logic_vector (N-1 downto 0);
  signal RAM: ram_type := (others => (others => '0'));

  begin
  
  -- TODO figure out why this is broken
  do <= RAM(to_integer(unsigned(r_addr)));
  
  write_data: process (we)
  begin
    if rising_edge(we) then
      RAM(to_integer(unsigned(w_addr))) <= di;
    end if;
  end process;
end architecture lab_6;
