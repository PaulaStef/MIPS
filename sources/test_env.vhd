----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2021 10:45:21 AM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
component MPG 
        Port (en : out STD_LOGIC;
        input : in STD_LOGIC;
        clock : in STD_LOGIC);
    end component;
 component SSD
            Port ( digits : in STD_LOGIC_VECTOR (15 downto 0);
                   clk : in STD_LOGIC;
                   cat : out STD_LOGIC_VECTOR (6 downto 0);
                   an : out STD_LOGIC_VECTOR (3 downto 0));   
        end component;
  component RF
         Port ( clk : in STD_LOGIC;
          RA1 : in STD_LOGIC_VECTOR(2 downto 0);
          RA2 : in STD_LOGIC_VECTOR(2 downto 0);
          WA : in STD_LOGIC_VECTOR(2 downto 0);
          WD : in STD_LOGIC_VECTOR(15 downto 0);
          RegWr : in STD_LOGIC;
          RD1 : out STD_LOGIC_VECTOR(15 downto 0);
          RD2 : out STD_LOGIC_VECTOR(15 downto 0) );
   end component;
   component RAM
         Port ( clk : in STD_LOGIC;
              address : in STD_LOGIC_VECTOR (3 downto 0);
              wd : in STD_LOGIC_VECTOR (15 downto 0);
              RamWr : in STD_LOGIC;
              rd : out STD_LOGIC_VECTOR (15 downto 0) );
   end component;
   component Instr_IF
     Port ( clk : in STD_LOGIC;
            en : in STD_LOGIC;
            rst : in STD_LOGIC;
            jump_address : in STD_LOGIC_VECTOR (15 downto 0);
            branch_address : in STD_LOGIC_VECTOR (15 downto 0);
            PCSrc : in STD_LOGIC;
            Jump : in STD_LOGIC;
            Instruction : out STD_LOGIC_VECTOR (15 downto 0);
            PC_plusOne : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    component Instruction_Decode
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
    end component;
    component UC
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
    end component;
    component EX
            Port ( rd1 : in STD_LOGIC_VECTOR (15 downto 0);
                   ALUSrc : in STD_LOGIC;
                   rd2 : in STD_LOGIC_VECTOR (15 downto 0);
                   Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
                   sa : in STD_LOGIC;
                   func : in STD_LOGIC_VECTOR (2 downto 0);
                   ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
                   ALURes : out STD_LOGIC_VECTOR (15 downto 0);
                   Zero : out STD_LOGIC);
         end component;
         
         component MEM
            Port ( clk : in STD_LOGIC;
                   MemWrite : in STD_LOGIC;
                   ALURes_In : in STD_LOGIC_VECTOR (15 downto 0);
                   rd2_rt : in STD_LOGIC_VECTOR (15 downto 0);
                   MemData : out STD_LOGIC_VECTOR (15 downto 0);
                   ALURes_Out : out STD_LOGIC_VECTOR (15 downto 0));
         end component;
         
signal enable1 : STD_LOGIC;   --PCsrc
signal enable2 : STD_LOGIC;   --Jump
signal jump_address: STD_LOGIC_VECTOR (15 downto 0) := x"0002";
signal branch_address: STD_LOGIC_VECTOR (15 downto 0) := x"0004";
signal instruction: STD_LOGIC_VECTOR (15 downto 0);
signal pc_plus_one: STD_LOGIC_VECTOR (15 downto 0);
signal digits: STD_LOGIC_VECTOR (15 downto 0);

signal RegDst : STD_LOGIC;
signal ExtOp : STD_LOGIC;
signal ALUSrc : STD_LOGIC;
signal Branch : STD_LOGIC;
signal NotBranch : STD_LOGIC;
signal PCSrc : STD_LOGIC; 
signal Jump : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR (1 downto 0);
signal MemWrite : STD_LOGIC;
signal MemtoReg : STD_LOGIC;
signal RegWrite : STD_LOGIC;

signal WD_signal : STD_LOGIC_VECTOR(15 downto 0);
signal rd1_rs_signal: STD_LOGIC_VECTOR(15 downto 0);
signal rd2_rt_signal: STD_LOGIC_VECTOR(15 downto 0);
signal ext_immediate_signal: STD_LOGIC_VECTOR(15 downto 0);
signal func_signal: STD_LOGIC_VECTOR(2 downto 0);
signal sa_signal: STD_LOGIC;
signal RegWrite_MPG: STD_LOGIC;

signal ALURes_In: STD_LOGIC_VECTOR(15 downto 0);

signal ALURes_Out: STD_LOGIC_VECTOR(15 downto 0);
signal MemData: STD_LOGIC_VECTOR(15 downto 0);
signal MemWrite_ENABLE: STD_LOGIC;
signal Zero: STD_LOGIC;
begin
C1: MPG port map (en => enable1, input => btn(0), clock => clk); 
C2: MPG port map (en => enable2, input => btn(1), clock => clk); 
C3: Instr_IF port map (clk => clk,
                       en => enable1,
                       rst => enable2,
                       jump_address => jump_address,
                       branch_address => branch_address,
                       PCSrc => branch,
                       Jump => Jump,
                       Instruction => instruction,
                       PC_plusOne => pc_plus_one);
C4: UC port map ( instr => instruction(15 downto 13),
                  RegDst => RegDst,
                  ExtOp => ExtOp,
                  ALUSrc => ALUSrc,
                  Branch => Branch,
                  NotBranch => NotBranch,
                  Jump => Jump,
                  ALUOp => ALUOp,
                  MemWrite => MemWrite,
                  MemtoReg => MemtoReg,
                  RegWrite => RegWrite);
              
C5: Instruction_Decode port map( clk => clk,
                                 instr => instruction,
                                 wd => WD_signal,
                                 RegWrite => RegWrite_MPG,
                                 RegDst => RegDst,
                                 ExtOp => ExtOp,
                                 rd1_rs => rd1_rs_signal,
                                 rd2_rt => rd2_rt_signal,
                                 Ext_imm => ext_immediate_signal,
                                 func => func_signal,
                                 sa => sa_signal);
C6: EX port map ( rd1 => rd1_rs_signal,
                                  ALUSrc => ALUSrc,
                                  rd2 => rd2_rt_signal,
                                  Ext_Imm => ext_immediate_signal,
                                  sa => sa_signal,
                                  func => func_signal,
                                  ALUOp => ALUOp,
                                  ALURes => ALURes_In,
                                  Zero => Zero);

C7: MEM port map ( clk => clk,
                   MemWrite => MemWrite_ENABLE,
                   ALURes_In => ALURes_In,
                   rd2_rt => rd2_rt_signal,
                   MemData => MemData,
                   ALURes_Out => ALURes_Out);

process(MemtoReg, ALURes_Out, MemData)
    begin
        case MemtoReg is
            when '0' => WD_signal <= ALURes_Out;
            when others => WD_signal <= MemData;
        end case;
 end process;
                                  
process(sw(7 downto 5),instruction,pc_plus_one,rd1_rs_signal, rd2_rt_signal, WD_signal, ext_immediate_signal, func_signal, sa_signal)
begin
case sw(7 downto 5) is
            when "000" => digits <= Instruction;
            when "001" => digits <= pc_plus_one;
            when "010" => digits <= rd1_rs_signal;
            when "011" => digits <= MemData;
            when "100" => digits <= WD_signal;
            when "101" => digits <= rd2_rt_signal;
            when "110" => digits <= ALURes_Out;
            when others => digits <= ext_immediate_signal;
        end case; 
end process;  
 MemWrite_ENABLE <= MemWrite AND enable1;
 jump_address <= "000" & Instruction(12 downto 0);
 branch_address <= ext_immediate_signal + pc_plus_one;
 PCSrc <= (Branch AND Zero) OR (NotBranch AND NOT(Zero));
 
SSD1: SSD port map( digits => digits, clk => clk, cat => cat, an => an);

    led(0) <= MemtoReg; 
    led(1) <= MemWrite; 
    led(2) <= Jump; 
    led(3) <= NotBranch; 
    led(4) <= Branch; 
    led(5) <= ALUOp(0); 
    led(6) <= ALUOp(1);
    led(7) <= ALUSrc; 
    led(8) <= ExtOp; 
    led(9) <= RegWrite; 
    led(10) <= RegDst; 
    led(11) <= Zero; 
    led(12) <= MemWrite_ENABLE;
    led(13) <= Instruction(13);
    led(14) <= Instruction(14); 
    led(15) <= Instruction(15);  
    
end Behavioral;
