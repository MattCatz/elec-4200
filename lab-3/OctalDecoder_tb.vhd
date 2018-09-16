-- OctalDecoder_tb.vhd

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.txt_util.all;

entity OctalDecoder_tb is
end OctalDecoder_tb;

architecture behav of OctalDecoder_tb is
    
    component OctalDecoder is
      port (
         D        : in  STD_LOGIC_VECTOR (2 downto 0);
         Segments : out  STD_LOGIC_VECTOR (6 downto 0)
      );
    end component;
    
  --  Specifies which entity is bound with the component.
  for OctalDecoder_0: OctalDecoder use entity work.OctalDecoder;
     signal D: STD_LOGIC_VECTOR (2 downto 0);
     signal Segments: STD_LOGIC_VECTOR (6 downto 0);
  begin
    OctalDecoder_0: OctalDecoder port map (D => D,
                                           Segments => Segments);

    process
      -- declare record type
      type test_vector is record
          D : std_logic_vector (2 downto 0);
          S : std_logic_vector (6 downto 0);
      end record;
        
      -- The patterns to apply
      type test_vector_array is array (natural range <>) of test_vector;
      constant test_vectors : test_vector_array := (
          ("000", "0000001"),  -- 0
          ("001", "1001111"),  -- 1
          ("010", "0010010"),  -- 2
          ("011", "0000110"),  -- 3
          ("100", "1001100"),  -- 4
          ("101", "0100100"),  -- 5
          ("110", "0100000"),  -- 6
          ("111", "0001111")); -- 7

    begin
    report "Starting tests" severity note;
    for i in test_vectors'range loop
      D <= test_vectors(i).D;
      wait for 1 ns;
      assert Segments = test_vectors(i).S report "Failed " & str(i) &": " & str(test_vectors(i).S) & "->" & str(Segments);
    end loop;
    report "End of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
