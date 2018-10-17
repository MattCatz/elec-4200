-- HexDecoder_tb.vhd

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.txt_util.all;

entity HexDecoder_tb is
end HexDecoder_tb;

architecture behav of HexDecoder_tb is
    
    component HexDecoder is
      port (
         D        : in  STD_LOGIC_VECTOR (3 downto 0);
         Segments : out  STD_LOGIC_VECTOR (6 downto 0)
      );
    end component;
    
  --  Specifies which entity is bound with the component.
  for HexDecoder_0: HexDecoder use entity work.HexDecoder;
     signal D: STD_LOGIC_VECTOR (3 downto 0);
     signal Segments: STD_LOGIC_VECTOR (6 downto 0);
  begin
    HexDecoder_0: HexDecoder port map (D => D,
                                       Segments => Segments);

    process
      -- declare record type
      type test_vector is record
          D : std_logic_vector (3 downto 0);
          S : std_logic_vector (6 downto 0);
      end record;
        
      -- The patterns to apply
      type test_vector_array is array (natural range <>) of test_vector;
      constant test_vectors : test_vector_array := (
          ("0000", "0000001"),  -- 0
          ("0001", "1001111"),  -- 1
          ("0010", "0010010"),  -- 2
          ("0011", "0000110"),  -- 3
          ("0100", "1001100"),  -- 4
          ("0101", "0100100"),  -- 5
          ("0110", "0100000"),  -- 6
          ("0111", "0001111"),  -- 7
          ("1000", "0000000"),  -- 8
          ("1001", "0001100"),  -- 9
          ("1010", "0001000"),  -- A
          ("1011", "1100000"),  -- B
          ("1100", "0110001"),  -- C
          ("1101", "1000010"),  -- D
          ("1110", "0110000"),  -- E
          ("1111", "0111000")); -- F

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
