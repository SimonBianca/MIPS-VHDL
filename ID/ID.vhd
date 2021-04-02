----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2020 20:28:15
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
    Port ( clk : in STD_LOGIC;
           en:in std_logic;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           regWrite : in STD_LOGIC;
           regDst : in STD_LOGIC;
           extOp : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           immExt : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end ID;

architecture Behavioral of ID is

component RF is
  Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           en:in std_logic);
end component;

signal out_regDst:std_logic_vector(2 downto 0);
signal out_rd1:std_logic_vector(15 downto 0);
signal out_rd2:std_logic_vector(15 downto 0);
begin
component1: RF port map (clk,instr(12 downto 10),instr(9 downto 7),out_regDst,wd,regWrite,out_rd1,out_rd2,en);
    process(instr(9 downto 4),regDst)
    begin
        if(regDst='1') then
            out_regDst<=instr(6 downto 4);
        else
            out_regDst<=instr(9 downto 7);
        end if;
    end process;
        
     process(instr(6 downto 0),extOP)
     begin
     if(extOp='0') then
        if instr(6)='1' then
              immExt<="111111111"&instr(6 downto 0);
	   else
	        immExt<="000000000"&instr(6 downto 0);
       end if;
     else
          immExt<="000000000"&instr(6 downto 0);
     end if;
     end process;
     rd1<=out_rd1;
     rd2<=out_rd2;
     func<=instr(2 downto 0);
     sa<=instr(3);
    
end Behavioral;
