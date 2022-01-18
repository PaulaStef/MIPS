----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2021 10:28:50 AM
-- Design Name: 
-- Module Name: Instr_IF - Behavioral
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

entity Instr_IF is
 Port (  clk : in STD_LOGIC;
          en : in STD_LOGIC;
          rst : in STD_LOGIC;
          jump_address : in STD_LOGIC_VECTOR (15 downto 0);
          branch_address : in STD_LOGIC_VECTOR (15 downto 0);
          PCSrc : in STD_LOGIC;
          Jump : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR (15 downto 0);
          PC_plusOne : out STD_LOGIC_VECTOR (15 downto 0));
end Instr_IF;

architecture Behavioral of Instr_IF is
type type_rom is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal memory : type_rom := (B"001_000_001_0000100",   --0.addi $1 $0 4     --2082
                             B"000_000_000_010_0_000",  --1.add $2 $0 $0    --0020
                             B"000_000_000_011_0_000", -- 2.add $3 $0 $0    --0030
                             B"000_000_000_100_0_000",  --3.add $4 $0 $0    --0040
                             B"000_000_000_101_0_000",   --4.add $5 $0 $0   --0050
                             B"000_000_000_110_0_000", -- 5.add $6 $0 $0    --0060
                             B"000_000_000_111_0_000", -- 6.add $7 $0 $0    --0070
                             B"100_001_010_0100011", -- 7.beq $2 $1 35      --8523
                             B"100_001_011_0011000", -- 8.beq $3 $1 24      --85A1
                             B"000_010_100_100_0_000", -- 9.add $4 $2 $4    --0A40
                             B"000_010_100_100_0_000", -- 10.add $4 $2 $4   --0A40
                             B"000_010_100_100_0_000", -- 11.add $4 $2 $4   --0A40
                             B"000_010_100_100_0_000", -- 12.add $4 $2 $4   --0A40
                             B"000_011_100_100_0_000", -- 13.add $4 $3 $4   --0E40
                             B"010_100_111_0000000", -- 14.lw $7 0($4)      --5380
                             B"000_000_000_100_0_000", -- 15.add $4 $0 $0   --0040
                             B"001_000_100_0010000", -- 16.addi $4 $0 16    --2210
                             B"000_010_100_100_0_000", -- 17.add $4 $2 $4   --0A40
                             B"010_100_101_0000000", -- 18.lw $5 0($4)      --5280
                             B"000_100_010_100_0_001", --19.sub &4 $4 $2    --1141
                             B"000_011_100_100_0_000", -- 20.add $4 $3 $4   --0E40
                             B"010_100_110_0000000", -- 21.lw $6 0($4)      --5300
                             B"000_101_100_111_0_000", -- 22.add $7 $5 $4   --1670
                             B"000_100_101_111_0_111", -- 23.slt $7 $4 $6   --127F
                             B"100_001_111_0011111", -- 24.beq $7 $1 31     --8797
                             B"000_101_000_100_0_000", -- 25.add $4 $6 $0   --1140
                             B"000_000_000_100_0_000", -- 26.add $4 $0 $0   --0040
                             B"001_000_100_0010000", -- 27.addi $4 $0 16    --2210
                             B"000_011_100_100_0_000", -- 28.add $4 $3 $4   --0E40
                             B"011_100_101_0000000", -- 29.sw $5 0($4)      --7280
                             B"111_0000000011000", -- 30.j 24               --0E18
                             B"001_000_011_0000001", -- 31.addi $3 $0 1     --2181
                             B"111_0000000001000", -- 32.j 8                --E008
                             B"001_000_010_0000001", -- 33.addi $2 $0 1     --2101
                             B"111_0000000000111", -- 34.j 7                --E007
                             others => "0000000000000000"); -- 0000
signal PC_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal address : STD_LOGIC_VECTOR(15 downto 0);
signal next_adr : STD_LOGIC_VECTOR(15 downto 0);
signal mux_branch : STD_LOGIC_VECTOR(15 downto 0);
begin

process(clk,en,rst)
begin
if(rst = '1') then
  PC_out <= x"0000";
else 
   if(rising_edge(clk)) then
    if( en = '1') then 
      PC_out <= address;
    end if;
   end if;
end if;
end process;

next_adr <= PC_out + '1';

process(PCsrc, next_adr, branch_address)
begin
case PCsrc is
  when '0' => mux_branch <= next_adr;
  when others => mux_branch <= next_adr;
end case;
end process;

process(Jump, jump_address, mux_branch)
begin
case Jump is
 when '0' => address <= mux_branch;
 when others => address <= Jump_address;
end case; 
end process;

Instruction <= memory(conv_integer(PC_out));
PC_plusOne <= next_adr;

end Behavioral;
