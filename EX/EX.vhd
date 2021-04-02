----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.04.2020 19:10:18
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
    Port ( PC : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           immExt : in STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           AluSrc : in STD_LOGIC;
           AluOp : in STD_LOGIC_VECTOR (1 downto 0);
           branchAddr : out STD_LOGIC_VECTOR (15 downto 0);
           AluRes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC;
           greaterThan0:out std_logic);
end EX;

architecture Behavioral of EX is
signal in2ALU:std_logic_vector(15 downto 0);
signal AluCtrl:std_logic_vector(2 downto 0);
signal adunare:std_logic_vector(15 downto 0);
signal scadere:std_logic_vector(15 downto 0);
signal shiftSt:std_logic_vector(15 downto 0);
signal shiftDr:std_logic_vector(15 downto 0);
signal orLogic:std_logic_vector(15 downto 0);
signal andLogic:std_logic_vector(15 downto 0);
signal shiftStVar:std_logic_vector(15 downto 0);
signal set:std_logic_vector(15 downto 0);
signal bitsOf0:std_logic_vector(15 downto 0):=x"0000";
signal result:std_logic_vector(15 downto 0);
signal resultShift:std_logic_vector(15 downto 0);
begin
    
    process(rd2,immExt,AluSrc)
    begin
        if AluSrc='0' then
            in2ALU<=rd2;
        else
            in2ALU<=immExt;
        end if;
    end process;
    
    process(AluOp,func)
    begin
        case AluOp is
        when"00"=>AluCtrl<="000";
        when"01"=>AluCtrl<="001";
        when "10"=>AluCtrl<=func;
        when others=>AluCtrl<="000"; 
        end case;
    end process;
     
     adunare<=rd1+in2ALU;
     scadere<=rd1-in2ALU;
     shiftSt<=rd2(14 downto 0)&'0';
     shiftDr<='0' & rd2(15 downto 1);
     andLogic<=rd1 and rd2;
     orLogic<=rd1 or rd2;
     
     process(rd1)
     begin
     case rd1 is
        when "0000"=>resultShift<=rd2;
        when"0001"=>resultShift<=rd2(14 downto 0) & bitsOf0(0);
        when"0010"=>resultShift<=rd2(13 downto 0) & bitsOf0(1 downto 0);
        when"0011"=>resultShift<=rd2(12 downto 0) & bitsOf0(2 downto 0);
        when"0100"=>resultShift<=rd2(11 downto 0) & bitsOf0(3 downto 0);
        when"0101"=>resultShift<=rd2(10 downto 0) & bitsOf0(4 downto 0);
        when"0110"=>resultShift<=rd2(9 downto 0) & bitsOf0(5 downto 0);
        when"0111"=>resultShift<=rd2(8 downto 0) & bitsOf0(6 downto 0);
        when"1000"=>resultShift<=rd2(7 downto 0) & bitsOf0(7 downto 0);
        when"1001"=>resultShift<=rd2(6 downto 0) & bitsOf0(8 downto 0);
        when"1010"=>resultShift<=rd2(5 downto 0) & bitsOf0(9 downto 0);
        when"1011"=>resultShift<=rd2(4 downto 0) & bitsOf0(10 downto 0);
        when"1100"=>resultShift<=rd2(3 downto 0) & bitsOf0(11 downto 0);
        when"1101"=>resultShift<=rd2(2 downto 0) & bitsOf0(12 downto 0);
        when"1110"=>resultShift<=rd2(1 downto 0) & bitsOf0(13 downto 0);
        when others=>resultShift<=rd2(0) & bitsOf0(14 downto 0);
      end case;
      end process;
    shiftStVar<=resultShift;
     process(rd1,rd2)
     begin
     if (rd1-rd2<0) then
        set<=x"1111";
     else
         set<=x"0000";
    end if;
    end process;
   
   process(AluCtrl,rd1,rd2)
   begin
        case AluCtrl is
            when "000"=>result<=adunare;
            when "001"=>result<=scadere;
            when "010"=>result<=shiftSt;
            when "011"=>result<=shiftDr;
            when "100"=>result<=andLogic;
            when "110"=>result<=shiftStVar;
            when others=>result<=set;
        end case;
     end process;
     
     process(result)
     begin
        if(result=x"0000") then
            zero<='1';
        else 
            zero<='0';
         end if;
        if(result>0) then
            greaterThan0<='1';
        else 
            greaterThan0<='0';
        end if;
      end process;
    
    AluRes<=result;
    branchAddr<=PC+immExt;

end Behavioral;
