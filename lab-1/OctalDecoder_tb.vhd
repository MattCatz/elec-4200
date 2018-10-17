-- OctalDecoder_tb.vhd

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity OctalDecoder_tb is
end OctalDecoder_tb;

architecture behav of OctalDecoder_tb is
    
    component OctalDecoder is
      port (
        D2, D1, D0    : in  STD_LOGIC;
        A,B,C,D,E,F,G : out STD_LOGIC
        -- D        : in  STD_LOGIC_VECTOR (2 downto 0);
        -- Segments : out  STD_LOGIC_VECTOR (6 downto 0)
      );
    end component;
    
  --  Specifies which entity is bound with the component.
  for OctalDecoder_0: OctalDecoder use entity work.OctalDecoder;
  signal D2, D1, D0, A,B,C,D,E,F,G : STD_LOGIC;
    -- signal D: STD_LOGIC_VECTOR (2 downto 0);
    -- signal Segments: STD_LOGIC_VECTOR (6 downto 0);
  begin
    OctalDecoder_0: OctalDecoder port map (D2 => D2,
                                          D1 => D1,
                                          D0 => D0,
                                          A  => A,
                                          B  => B,
                                          C  => C,
                                          D  => D,
                                          E  => E,
                                          F  => F,
                                          G  => G);

    -- OctalDecoder_0: OctalDecoder port map (D(2) => D(2),
    --                                       D(1) => D(1),
    --                                       D(0) => D(0),
    --                                       Segments(6) => Segments(6),
    --                                       Segments(5) => Segments(5),
    --                                       Segments(4) => Segments(4),
    --                                       Segments(3) => Segments(3),
    --                                       Segments(2) => Segments(2),
    --                                       Segments(1) => Segments(1),
    --                                       Segments(0) => Segments(0));

    process
      -- declare record type
      type test_vector is record
          D2, D1, D0 : std_logic;
          A,B,C,D,E,F,G : std_logic;
      end record;
        
      -- The patterns to apply
      type test_vector_array is array (natural range <>) of test_vector;
      constant test_vectors : test_vector_array := (
        --  D2,  D1,  D0,  A,   B,   C,   D,   E,   F,   G
          ('0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), -- 0
          ('0', '0', '1', '1', '0', '0', '1', '1', '1', '1'), -- 1
          ('0', '1', '0', '0', '0', '1', '0', '0', '1', '0'), -- 2
          ('0', '1', '1', '0', '0', '0', '0', '1', '1', '0'), -- 3
          ('1', '0', '0', '1', '0', '0', '1', '1', '0', '0'), -- 4
          ('1', '0', '1', '0', '1', '0', '0', '1', '0', '0'), -- 5
          ('1', '1', '0', '0', '1', '0', '0', '0', '0', '0'), -- 6
          ('1', '1', '1', '0', '0', '0', '1', '1', '1', '1')  -- 7
          );

    begin
    -- Check each pattern
    for i in test_vectors'range loop
      assert false report "No failures yet..." severity note;
      -- Set the inputs
      D2 <= test_vectors(i).D2;
      D1 <= test_vectors(i).D1;
      D0 <= test_vectors(i).D0;
      -- D(2) <= test_vectors(i).D2;
      -- D(1) <= test_vectors(i).D1;
      -- D(0) <= test_vectors(i).D0;
      wait for 1 ns;
      -- Check for the results
      assert A = test_vectors(i).A report "Failed A";
      assert B = test_vectors(i).B report "Failed B";
      assert C = test_vectors(i).C report "Failed C";
      assert D = test_vectors(i).D report "Failed D";
      assert E = test_vectors(i).E report "Failed E";
      assert F = test_vectors(i).F report "Failed F";
      assert G = test_vectors(i).G report "Failed G";
      -- assert Segments(6) = test_vectors(i).A report "Failed A";
      -- assert Segments(5) = test_vectors(i).B report "Failed B";
      -- assert Segments(4) = test_vectors(i).C report "Failed C";
      -- assert Segments(3) = test_vectors(i).D report "Failed D";
      -- assert Segments(2) = test_vectors(i).E report "Failed E";
      -- assert Segments(1) = test_vectors(i).F report "Failed F";
      -- assert Segments(0) = test_vectors(i).G report "Failed G";
    end loop;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
