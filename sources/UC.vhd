----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2021 11:45:40 AM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
  Port ( Instr : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           NotBranch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end UC;

architecture Behavioral of UC is

begin
process(Instr)
    begin
           RegDst <= '0';
           ExtOp <= '0';
           ALUSrc <= '0';
           Branch <= '0';
           NotBranch <= '0';
           Jump <= '0';
           ALUOp <= "00";
           MemWrite <= '0';
           MemtoReg <= '0';
           RegWrite <= '0';
           
           case Instr is
                --R
                when "000" => RegDst <= '1';
                              RegWrite <= '1';
                              ALUOp <= "10";
                --ADDI              
                when "001" => RegWrite <= '1';
                              ExtOp <= '1';
                              ALUSrc <= '1';
                --LW            
                when "010" => RegWrite <= '1';
                              ExtOp <= '1';
                              ALUSrc <= '1';
                              MemtoReg <= '1';
                --SW              
                when "011" => ExtOp <= '1';
                              ALUSrc <= '1';
                              MemWrite <= '1';
                --BEQ
                when "100" => ExtOp <= '1';
                              ALUOp <= "01";
                              Branch <= '1';
                --BNE
                when "101" => ExtOp <= '1';
                              ALUOp <= "01";
                              NotBranch <= '1';
                --SLTI
                when "110" => RegWrite <= '1';
                              ExtOp <= '1';
                              ALUSrc <= '1';
                              ALUOp <= "11";
                --Jump
                when others => Jump <= '1';
           end case; 
    end process;

end Behavioral;
