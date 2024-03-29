-- Top level VHDL for PICOBLAZE TEST for ELEC4200
--
-- Edit ports for NEXYS 4 inputs/outputs used by the application
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity TutorialTopLevel is
    Port (       switches : in std_logic_vector(3 downto 0);
                 Segments: out std_logic_vector(6 downto 0);
                 AN: out std_logic_vector(7 downto 0);
                 clk : in std_logic);
end TutorialTopLevel;

architecture Behavioral of TutorialTopLevel is
--
-- Declaration of the KCPSM6 processor component
--
  component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;

--
-- Declaration of the default Program Memory recommended for development.
--
-- The name of this component should match the name of your PSM file.
--
  component lab8 is
      Port (      address : in std_logic_vector(11 downto 0);
              instruction : out std_logic_vector(17 downto 0);
                   enable : in std_logic;
                      clk : in std_logic);
      end component lab8;

signal         address : std_logic_vector(11 downto 0);
signal     instruction : std_logic_vector(17 downto 0);
signal     bram_enable : std_logic;
signal         in_port : std_logic_vector(7 downto 0);
signal        out_port : std_logic_vector(7 downto 0);
signal         port_id : std_logic_vector(7 downto 0);
signal    write_strobe : std_logic;
signal  k_write_strobe : std_logic;
signal     read_strobe : std_logic;
signal       interrupt : std_logic;
signal   interrupt_ack : std_logic;
signal    kcpsm6_sleep : std_logic;
signal    kcpsm6_reset : std_logic;

signal               Q : std_logic_vector(6 downto 0);

begin
  -- Instantiating the PicoBlaze core
  processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);
 
  --
  -- In many designs (especially your first) reset, interrupt and sleep are not used.
  -- Tie these inputs Low until you need them. Tying 'interrupt' to 'interrupt_ack' 
  -- preserves both signals for future use and avoids a warning message.
  -- 
  kcpsm6_reset <= '0';
  kcpsm6_sleep <= '0';
  interrupt <= interrupt_ack;

  -- Instantiating the program ROM
  program_rom: lab8                    --Name to match your PSM file
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       clk => clk);
                       
  output_latch: process(clk)
  begin
    if rising_edge(clk) then
        if write_strobe='1' then
            Q <= out_port(6 downto 0);
        end if;
     end if;
   end process output_latch;

   -- Connect I/O of PicoBlaze
  in_port(7 downto 4) <= "0000";
  in_port(3 downto 0) <= switches(3 downto 0);
  Segments <= Q;
  AN <= "11111110";

 end Behavioral;
