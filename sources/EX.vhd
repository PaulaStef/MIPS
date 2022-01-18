----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2021 11:11:16 AM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
Port (     rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC);
end EX;

architecture Behavioral of EX is
signal out_mux : STD_LOGIC_VECTOR(15 downto 0);
signal ALUctrl : STD_LOGIC_VECTOR(2 downto 0);
signal set_on_less_than_signal : STD_LOGIC;
signal set_on_less_than: STD_LOGIC_VECTOR(15 downto 0);
signal result: STD_LOGIC_VECTOR(15 downto 0);

begin
process(rd2,Ext_Imm,ALUSrc)
begin
case ALUSrc is
     when '0' => out_mux <= RD2;
     when others => out_mux <= Ext_Imm;
     end case;
end process;

process(ALUop,func)
begin
case ALUop is
     when "00" => ALUctrl <= "000";
     when "01" => ALUctrl <= "001";
     when "11" => ALUctrl <= "111";
     when others => ALUctrl <= func;
end case;
end process;

process(ALUctrl,sa,RD1,out_mux)
begin
if( rd1<out_mux) then
    set_on_less_than_signal <= '1';
  else
    set_on_less_than_signal <= '0';
end if;

if ( set_on_less_than_signal = '1') then
   set_on_less_than <= "0000000000000001";
else
   set_on_less_than <= "0000000000000000";
end if;
        case ALUctrl is
            when "000" => result <= rd1 + out_mux;                  
            when "001" => result <= rd1 - out_mux;                    
            when "010" => if(sa = '0') then
                             result <= rd1(14 downto 0) & '0';
                           else 
                              result <= rd1(13 downto 0) & "00";  
                            end if;                          
            when "011" => if(sa = '0') then
                          result <= '0' & rd1(15 downto 1);
                          else
                          result <= "00" & rd1(15 downto 2);
                          end if;                                 
            when "100" => result <= rd1 AND out_mux;                  
            when "101" => result <= rd1 OR out_mux;                    
            when "110" => result <= rd1 XOR out_mux;                
            when others => result <= set_on_less_than;
        end case;
end process;
Zero <= '1' when result = "0000000000000000" else '0';
ALUres <= result;
end Behavioral;
