----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.04.2020 23:51:31
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
          address:in STD_LOGIC_VECTOR(15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           memWrite : in STD_LOGIC;
           memData : out STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           AluRes : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
type mem_array is array(0 to 255) of std_logic_vector (15 downto 0);
signal MEM:mem_array:=(x"0000",x"0001",x"0002",x"0003",
                       x"0004",x"0005",x"0006",x"0007",
                       x"0008",x"0009",x"000A",x"000B",
                       x"000C",x"000D",x"000E",x"000F",
                       others=>x"FFFF");
signal read_data:std_logic_vector(15 downto 0);

begin
 process(clk)
    begin
    if rising_edge(clk) then
        if en='1' then
            if memWrite='1' then
              MEM(conv_integer(address(7 downto 0)))<=rd2;
            end if;
        end if;
    end if;
    end process;
    memData<=MEM(conv_integer(address(7 downto 0)));
    AluRes<=address;


end Behavioral;
