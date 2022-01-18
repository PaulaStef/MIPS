----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2021 10:28:57 AM
-- Design Name: 
-- Module Name: Instruction_Decode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_Decode is
  Port (  clk : in STD_LOGIC;
          Instr : in STD_LOGIC_VECTOR (15 downto 0);
          wd : in STD_LOGIC_VECTOR (15 downto 0);
          RegWrite : in STD_LOGIC;
          RegDst : in STD_LOGIC;
          ExtOp : in STD_LOGIC;
          rd1_rs : out STD_LOGIC_VECTOR (15 downto 0);
          rd2_rt : out STD_LOGIC_VECTOR (15 downto 0);
          Ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
          func : out STD_LOGIC_VECTOR (2 downto 0);
          sa : out STD_LOGIC);
end Instruction_Decode;

architecture Behavioral of Instruction_Decode is

component RF
        Port ( clk : in STD_LOGIC; 
               ra1 : in STD_LOGIC_VECTOR (2 downto 0);
               ra2 : in STD_LOGIC_VECTOR (2 downto 0);
               wa : in STD_LOGIC_VECTOR (2 downto 0);
               wd : in STD_LOGIC_VECTOR (15 downto 0);
               RegWR : in STD_LOGIC;
               rd1 : out STD_LOGIC_VECTOR (15 downto 0);
               rd2 : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
signal write_RF : STD_LOGIC_VECTOR(2 downto 0);
begin

process(RegDst, Instr(9 downto 7), Instr(6 downto 4))
    begin
        case RegDst is
            when '0' => write_RF <= Instr(9 downto 7);
            when others => write_RF <= Instr(6 downto 4);
        end case;
    end process;
C1: RF port map (clk => clk, 
                       ra1 => Instr(12 downto 10), 
                       ra2 => Instr(9 downto 7), 
                       wa => write_RF,
                       wd => wd,
                       RegWR => RegWrite, 
                       rd1 => rd1_rs, 
                       rd2 => rd2_rt);
process(ExtOp, Instr)
begin
If(ExtOp = '1') then
    Ext_Imm <= "000000000" & Instr(6 downto 0);
  else 
    if(Instr(6) = '1') then
     Ext_Imm <= "111111111" & Instr(6 downto 0);
    else
      Ext_Imm <= "000000000" & Instr(6 downto 0);
    end if;
 end if;       
end process; 
func <= Instr(2 downto 0);
sa <= Instr(3);          
end Behavioral;
