----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2021 09:35:47 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
  Port ( clk : in STD_LOGIC;
          MemWrite : in STD_LOGIC;
          ALURes_In : in STD_LOGIC_VECTOR (15 downto 0);
          rd2_rt : in STD_LOGIC_VECTOR (15 downto 0);
          MemData : out STD_LOGIC_VECTOR (15 downto 0);
          ALURes_Out : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
component RAM 
        Port ( clk : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           RamWr : in STD_LOGIC;
           rd : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
begin
 C1: RAM port map (clk => clk,
                      address => ALURes_In,
                      wd => rd2_rt,
                      RamWr => MemWrite,
                      rd => MemData);
                              
    ALURes_Out <= ALURes_In;

end Behavioral;
