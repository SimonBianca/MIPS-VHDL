----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2020 17:59:48
-- Design Name: 
-- Module Name: IFunit - Behavioral
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

entity IFunit is
    Port ( en : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           jmpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           branchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           jmp : in STD_LOGIC;
           PC : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0));
end IFunit;

architecture Behavioral of IFunit is
signal in_PC:std_logic_vector(15 downto 0):=x"0000";
signal out_PC:std_logic_vector(15 downto 0);
signal out_mux_PC:std_logic_vector(15 downto 0);
signal out_mux_jmp:std_logic_vector(15 downto 0);

signal out_mem:std_logic_vector(15 downto 0);
type mRom is array(0 to 255) of std_logic_vector(15 downto 0);
signal ROM: mRom:=(
x"0824", -- and $2,$2,$0
x"0C34", -- and $3,$3,$0
x"1044", -- and $4,$4,$0
x"1C74", -- and $7,$7,$0
x"2D84", -- andi $3,$3,4
x"0414", -- and $1,$1,$0
x"4881", -- lw $1,1($2)
x"10C0", -- add $4,$4,$1
x"2901", -- addi $2,$2,1
x"8981", -- beq $2,$3,1
x"E006", -- jmp 6
x"024B", -- srl $4,$4,1
x"024B", -- srl $4,$4,1
x"3F83", -- addi $7,$7,3
x"1E46", -- sllv $4,$4,$7
x"760F", -- sw $4,15($5)
others=>x"FFFF");
begin
    process (clk,out_mux_jmp,rst)
    begin
         if rst='1' then
            in_PC<=x"0000";
         end if;
        if rising_edge(clk) then
            if en='1' then
               in_PC<=out_mux_jmp;
             end if;
         end if;
     end process;
     
     out_PC<=in_PC+1;
     
     process(out_PC,branchAddr,PcSrc)
     begin
     case PCSrc is
        when '0' => out_mux_PC<=out_PC;
        when others=> out_mux_PC<=branchAddr;
     end case;
     end process;
     
     process(out_mux_PC,jmpAddr,jmp)
     begin
     case jmp is
        when '0' => out_mux_jmp<=out_mux_PC;
        when others=> out_mux_jmp<=jmpAddr;
     end case;
     end process;
    
    out_mem<=ROM(conv_integer(in_PC(7 downto 0)));
    PC<=out_PC;
    instr<=out_mem;

end Behavioral;
