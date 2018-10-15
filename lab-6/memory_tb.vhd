Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.txt_util.all;

entity Memory_tb is
end entity Memory_tb;

architecture testbench of Memory_TB is

	constant addr_len : Natural := 8;
	constant register_size : Natural := 8;

	signal ENABLE, WRITE_ENABLE: STD_LOGIC := '0';
	signal R_ADDR, W_ADDR: STD_LOGIC_VECTOR(ADDR_LEN-1 downto 0);
	signal D_IN, D_OUT: STD_LOGIC_VECTOR(register_size-1 downto 0);


	begin
  	memory: entity work.memory generic map (addr_len, register_size)
    port map (WE=>WRITE_ENABLE, r_addr=>r_addr, w_addr=>w_addr, di=>D_IN, do=>D_OUT);

  process
    procedure STAGE_ONE is
    begin
      R_ADDR <= (others => '0');
      for i in 0 to (2**ADDR_LEN)-1 loop
        D_IN <= STD_LOGIC_VECTOR(to_unsigned(i, register_size));
        W_ADDR <= STD_LOGIC_VECTOR(to_unsigned(i, addr_len));
        wait for 1 ns;
        WRITE_ENABLE <= '1';
        wait for 1 ns;
        WRITE_ENABLE <= '0';
      end loop;
    end procedure STAGE_ONE;

    procedure STAGE_TWO is
    begin
      for i in 0 to (2**ADDR_LEN)-1 loop

        R_ADDR <= STD_LOGIC_VECTOR(to_unsigned(i, ADDR_LEN));
        wait for 1 ns;
        assert i = to_integer(unsigned(D_OUT))
          report "Failure to read adress in stage two" severity failure;

        D_IN <= not STD_LOGIC_VECTOR(to_unsigned(i, register_size));
        W_ADDR <= STD_LOGIC_VECTOR(to_unsigned(i, ADDR_LEN));
        wait for 1 ns;
        WRITE_ENABLE <= '1';
        wait for 1 ns;
        WRITE_ENABLE <= '0';
      end loop;
    end procedure STAGE_TWO;

    procedure STAGE_THREE is
    begin
      for i in 0 to (2**ADDR_LEN)-1 loop
        R_ADDR <= not STD_LOGIC_VECTOR(to_unsigned(i, ADDR_LEN));
        wait for 1 ns;
        assert i = to_integer(unsigned(D_OUT))
          report "Failure to read adress in stage three" severity failure;

        W_ADDR <= not STD_LOGIC_VECTOR(to_unsigned(i, ADDR_LEN));
        D_IN <= STD_LOGIC_VECTOR(to_unsigned(i, register_size));
        wait for 1 ns;
        WRITE_ENABLE <= '1';
        wait for 1 ns;
        WRITE_ENABLE <= '0';
      end loop;
    end procedure STAGE_THREE;

    procedure STAGE_FOUR is
    begin
      for i in 0 to (2**ADDR_LEN)-1 loop
        R_ADDR <= STD_LOGIC_VECTOR(to_unsigned(i, ADDR_LEN));
        wait for 1 ns;
        assert i = to_integer(unsigned(not D_OUT))
          report "Failure to read adress in stage four" severity failure;
      end loop;
    end procedure STAGE_FOUR;

  begin

  STAGE_ONE;
  wait for 5 ns;
  STAGE_TWO;
  wait for 5 ns;
  STAGE_THREE;
  wait for 5 ns;
  STAGE_FOUR;
  wait;

  end process;

end architecture testbench;
