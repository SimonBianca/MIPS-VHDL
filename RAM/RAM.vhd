----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2020 19:51:45
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
 Port    ( clk : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           di : in STD_LOGIC_VECTOR (15 downto 0);
           do : out STD_LOGIC_VECTOR (15 downto 0));
end RAM;

architecture Behavioral of RAM is
type ram_array is array(0 to 15) of std_logic_vector (15 downto 0);
signal RAM:ram_array:=(x"0000",x"0001",x"0002",x"0003",
                       x"0004",x"0005",x"0006",x"0007",
                       x"0008",x"0009",x"000A",x"000B",
                       x"000C",x"000D",x"000E",x"000F",
                       others=>x"0000");
signal read_addr:std_logic_vector(15 downto 0);


begin
    process(clk)
    begin
    if rising_edge(clk) then
        if wen='1' then
            RAM(conv_integer(addr))<=di;
        end if;
        read_addr<=addr;
    end if;
    end process;
     do<=RAM(conv_integer(read_addr));
end Behavioral;
