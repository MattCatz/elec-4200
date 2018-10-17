----------------------------------------------------------------------------------
-- Engineer: Matthew Cather
--
-- Create Date: 9/16/18
-- Module Name: Moore_FSM_Equations_FD
-- Project Name: Sequential Logic Design
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Moore_FSM_Equations_FD is
    Port ( CLK : in STD_LOGIC; --Clock
           RST : in STD_LOGIC; --Active Low synchcronus reset
           PB : in STD_LOGIC;  --Active High clock enable from pushbutton
           Cout : out STD_LOGIC_VECTOR (1 downto 0);  --current state
           Oout : out STD_LOGIC_VECTOR (3 downto 0)); --position  state
end Moore_FSM_Equations_FD;

architecture Behavioral of Moore_FSM_Equations_FD is
---------------------Begin template signals----------------------------
signal C : STD_LOGIC_VECTOR(1 downto 0) :="00";  --Internal signal for output C, which is a binary representation of the current state
signal O : STD_LOGIC_VECTOR (3 downto 0) :="1110"; --Internal signal for output O, which is a one-cold representation of the current state
signal X,Y,Z,EN: STD_LOGIC; --Signals for the digital one-shot and enable
---------------------End template signals------------------------------
begin

-- Template for D flip-flop model
-- Copy and paste for each D flip-flop instance
-- Each instance must have a unique Instance_Label
-- Substitute actual signal names for CLK, Q-output, D-input
--
--Instance_Label :  process (CLK)
--                  begin
--                      if rising_edge(CLK) then
--                            Q-output <= D-input;
--                      end if;
--                  end process;


---------------Begin digital one-shot model---------------------------
---------------Study, but do not edit!--------------------------------

-- First D flip-flop of the one-shot circuit
ONESHOTFF1 : process (CLK)
  begin
    if rising_edge(CLK) then  -- trigger on rising clock edge
      X <= PB;                -- PB = D-input, X = Q-output
    end if;
  end process;

-- Second D flip-flop of the one-shot circuit
ONESHOTFF2 : process (CLK)
  begin
    if rising_edge(CLK) then  -- trigger on rising clock edge
      Y <= X;                 -- X = D-input, Y = Q-output
    end if;
  end process;

-- Third D flip-flop of the one-shot circuit
ONESHOTFF3 : process (CLK)
  begin
    if rising_edge(CLK) then  -- trigger on rising clock edge
      Z <= Y;                 -- Y = D-input, Z = Q-output
    end if;
  end process;

--Create enable signal with the output of the oneshot
--Disabled for testing
--EN <= Y and not Z;
EN <= PB;

---------------------End digital one-shot code---------------------

Cout <= C;
Oout <= O;
---------------------Enter your code below-------------------------

process (CLK) is
begin
  if rising_edge(CLK) then
    if RST = '1' then -- GOTO A
        C <= "00";
        O <= "1110";
     elsif EN = '1' then
        case C is
          when "00" => -- A
            C <= "01";
            O <= "1101";
          when "01" => -- B
            C <= "10";
            O <= "1011";
          when "10" => -- C
            C <= "11";
            O <= "0111";
          when others =>
            C <= "00";
            O <= "1110";                    
        end case;
      else
        C <= C;
        O <= O;
     end if;
  end if;
end process;
end Behavioral;
