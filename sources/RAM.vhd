----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2021 07:55:30 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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

entity RAM is
    Port ( clk : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           RamWr : in STD_LOGIC;
           rd : out STD_LOGIC_VECTOR (15 downto 0) );
end RAM;

architecture Behavioral of RAM is
type ram_array is array (0 to 20) of STD_LOGIC_VECTOR (15 downto 0);
signal ram_memory: ram_array := ( x"0000",    --Ponderea muchiei dintre nodul 1 si nodul 1 e 0
                                  x"0001",    --[1][2]
                                  x"0002",    --[1][3]
                                  x"0005",    --[1][4]
                                  
                                  x"0001",    --[2][1]
                                  x"0000",    --[2][2]
                                  x"0007",    --[2][3]
                                  x"0006",    --[2][4]
                                  
                                  x"0002",    --[3][1]
                                  x"0007",    --[3][2]
                                  x"0000",    --[3][3]
                                  x"0008",    --[3][4]
                                  
                                  x"0005",     --[4][1]
                                  x"0006",     --[4][2]
                                  x"0008",     --[4][3]
                                  x"0000",     --[4][4]
                                  
                                  x"0000",     --shortest path 1-1
                                  x"7FFF",     --shortest path 1-2 (initializam cu max)
                                  x"7FFF",     --shortest path 1-3
                                  x"7FFF",     --shortest path 1-4
                                 others => x"0000");
begin
 process(clk, RamWr, wd)
    begin
        if(clk'event and clk = '1') then
            if(RamWr = '1') then
                ram_memory(conv_integer(address)) <= wd;
            end if;
        end if;   
    end process;
    rd <= ram_memory(conv_integer(address));
end Behavioral;
