Library IEEE;
use IEEE.std_logic_1164.all;

entity lab_11_heiarchy is
  Port (PB : in std_logic;
        INPUT_DATA : in std_logic_vector(5 downto 0);
        SEGMENTS : out std_logic_vector(6 downto 0);
        DISPLAY_ENABLE: out std_logic_vector(3 downto 0);
        CLK: in std_logic);
end lab_11_heiarchy;

architecture Behavioral of lab_11_heiarchy is
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

signal PBdb : std_logic := '0';
signal SCK : std_logic := '0';

signal MOSI,SCK,ACK,RDY: std_logic := '0';
    
signal OUTPUT_DATA: std_logic_vector(5 downto 0);

begin
  -- Instantiating the PicoBlaze core
  processor: entity WORK.kcpsm6
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
  kcpsm6_reset <= '0';
  kcpsm6_sleep <= '0';

  -- Instantiating the program ROM
  program_rom: entity WORK.lab9
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       clk => clk);

   -- Connect I/O of PicoBlaze
   
   DB: entity WORK.Debounce port map(CLK=>CLK, PB=>PB, PBdb=>PBdb);
   One_Shot: entity  WORK.One_Shot_Timer port map(CLK=>CLK, PB=>PBdb, EN=>SCK);
   reciver: entity WORK.spi_receiver port map(MOSI=>MOSI,SCK=>SCK,ACK=>interrupt_ack,CLK=>CLK,RDY=>interrupt,OUTPUT=>in_port,RST=>'0');
   
   
   reg_segments: entity WORK.output_port generic map(11) port map(clk=>clk, output=>port_2_output, input => in_port(3 downto 0), enable => port_id(1), strobe => write_strobe);
   display: entity WORK.HexDecoder port map (D=>OUTPUT_DATA, segments=>segments);



  in_port(7 downto 4) <= "0000";
  LEDS(3 downto 0) <= port_2_output;
  LEDS(7 downto 4) <= port_4_output;

 end Behavioral;
