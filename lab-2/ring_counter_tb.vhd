library ieee;
use ieee.std_logic_1164.all;

library work;
use work.txt_util.all;

entity ring_counter_tb is
end entity;

architecture testbench of ring_counter_tb is 

  component Moore_FSM_Equations_FD is
    port (
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           PB : in STD_LOGIC;
           Cout : out STD_LOGIC_VECTOR (1 downto 0);
           Oout : out STD_LOGIC_VECTOR (3 downto 0)
    );
  end component;

  for ring_counter: Moore_FSM_Equations_FD use entity work.Moore_FSM_Equations_FD;
  signal CLK : STD_LOGIC := '0';
  signal FIN : STD_LOGIC := '0';
  signal RST, PB : STD_LOGIC;
  signal C : STD_LOGIC_VECTOR (1 downto 0);
  signal O : STD_LOGIC_VECTOR (3 downto 0);
  constant half_period : TIME := 5 ns;
  
  begin
    ring_counter: Moore_FSM_Equations_FD port map (CLK => CLK,
                                                   RST => RST,
                                                   PB  => PB,
                                                   Cout   => C,
                                                   Oout   => O);
  gen_clk : process (CLK)
  begin
      --assert false report "clock" severity note;
      if FIN = '0' then
        CLK <= not CLK after half_period;
      else
	CLK <= '0';
      end if;
  end process;

  process
    type test_vector is record
       RST, PB : STD_LOGIC;
       O : STD_LOGIC_VECTOR (3 downto 0);
       C : STD_LOGIC_VECTOR (1 downto 0);
    end record;

    type test_vector_array is array (natural range <>) of test_vector;
    constant test_vectors : test_vector_array := (
      -- RST    PB   O       C
         ('0', '0',  "1110", "00"), --Check init state
         ('0', '1',  "1101", "01"), --A->B
         ('0', '1',  "1011", "10"), --B->C
         ('0', '1',  "0111", "11"), --C->D
         ('0', '1',  "1110", "00")  --D->A
    );
    begin
      report "Starting Loop" severity note;
      for i in test_vectors'range loop
	report "Vector: " & str(i);
        RST <= test_vectors(i).RST; 
        PB  <= test_vectors(i).PB;
        wait until rising_edge(CLK);
	wait for 1 ns; --transition time
        assert O = test_vectors(i).O report "Failed O:" & str(test_vectors(i).O) & "->" & str(O); 
        assert C = test_vectors(i).C report "Failed C:" & str(test_vectors(i).C) & "->" & str(C);
      end loop;
      report "end of test" severity note;
      FIN <= '1';
      report "stopping clock" severity note;
      wait;
  end process;

end testbench;
