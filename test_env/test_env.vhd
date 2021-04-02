----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2020 20:46:50
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
component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component SSD is
 Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component RF is
 Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           en:std_logic);
end component;

component RAM is
Port    ( clk : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           di : in STD_LOGIC_VECTOR (15 downto 0);
           do : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component IFunit is
   Port ( clk: in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           jmpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           branchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           jmp : in STD_LOGIC;
           PC : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0));
 end component;
 
 component ID is
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
end component;

component EX is
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
end component;
component MEM is
Port ( clk : in STD_LOGIC;
          address:in STD_LOGIC_VECTOR(15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           memWrite : in STD_LOGIC;
           memData : out STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           AluRes : out STD_LOGIC_VECTOR (15 downto 0));
 end component;
signal en:std_logic;
signal count_int:std_logic_vector(15 downto 0);
signal zero1:std_logic_vector(15 downto 0);
signal zero2:std_logic_vector(15 downto 0);
signal zero3:std_logic_vector(15 downto 0);
signal suma:std_logic_vector(15 downto 0);
signal scadere:std_logic_vector(15 downto 0);
signal shiftst:std_logic_vector(15 downto 0);
signal shiftdr:std_logic_vector(15 downto 0);
signal count:std_logic_vector(1 downto 0);
signal out_mux2:std_logic_vector(15 downto 0);

signal do:std_logic_vector(15 downto 0);
type mRom is array(0 to 255) of std_logic_vector(15 downto 0);
signal ROM: mRom:=( others=>x"0000");
signal count_rom:std_logic_vector(15 downto 0);

signal wen:std_logic;
signal count_rf:std_logic_vector(2 downto 0);
signal suma_rf:std_logic_vector(15 downto 0);
signal out_rd1:std_logic_vector(15 downto 0);
signal out_rd2:std_logic_vector(15 downto 0);

signal count_ram:std_logic_vector(15 downto 0);
signal shift_st:std_logic_vector(15 downto 0);
signal do_ram:std_logic_vector(15 downto 0);

signal en_rst:std_logic;
signal out_display:std_logic_vector(15 downto 0);
signal PC:std_logic_vector(15 downto 0);
signal instr:std_logic_vector(15 downto 0);

signal regDst:std_logic;
signal extOp:std_logic;
signal AluSrc:std_logic;
signal Branch:std_logic;
signal jump:std_logic;
signal AluOp:std_logic_vector(1 downto 0);
signal memWrite:std_logic;
signal memToReg:std_logic;
signal regWrite:std_logic;
signal regWriteFinal:std_logic;
signal immExt:STD_LOGIC_VECTOR (15 downto 0);
signal func :STD_LOGIC_VECTOR (2 downto 0);
signal sa :STD_LOGIC;
signal branchne:std_logic;

signal mux_wb:std_logic_vector(15 downto 0);
signal AluRes:std_logic_vector(15 downto 0);
signal memData:std_logic_vector(15 downto 0);
signal Zero :STD_LOGIC;
signal greaterThan0:std_logic;
signal PCSrc:std_logic;
signal branchGTZ:std_logic;
signal branchAddr:std_logic_vector(15 downto 0);
signal jmpAddr:std_logic_vector(15 downto 0);
signal memWriteFinal:std_logic;

begin

--component1: MPG port map(btn(1),clk, en);
--component2: SSD port map(count_int(3 downto 0),count_int(7 downto 4),count_int(11 downto 8),count_int(15 downto 12),clk,an,cat);
--component3: SSD port map(out_mux2(3 downto 0), out_mux2(7 downto 4), out_mux2(11 downto 8),out_mux2(15 downto 12),clk,an,cat);
--component4: SSD port map(do(3 downto 0), do(7 downto 4), do(11 downto 8),do(15 downto 12),clk,an,cat);
--component5: MPG port map(btn(0),clk,wen);
--component6: RF port map(clk, count_rf,count_rf,count_rf,suma_rf,wen,out_rd1,out_rd2,en);
--component7: SSD port map(suma_rf(3 downto 0), suma_rf(7 downto 4), suma_rf(11 downto 8),suma_rf(15 downto 12),clk,an,cat);
--component8: SSD port map(shift_st(3 downto 0), shift_st(7 downto 4), shift_st(11 downto 8),shift_st(15 downto 12),clk,an,cat);
--component9: RAM port map(clk,count_ram,wen,shift_st,do_ram);
component10: MPG port map(btn=>btn(0),clk=> clk,en=> en);
component11: MPG port map(btn=>btn(1),clk=> clk,en=> en_rst);
component12: IFunit port map(en=>en,clk=>clk,rst=>en_rst,jmpAddr=>jmpAddr,branchAddr=>branchAddr,PCSrc=>PCSrc,jmp=>Jump,PC=>PC,instr=>instr);
component13: SSD port map(digit0=>out_display(3 downto 0),digit1=> out_display(7 downto 4),digit2=> out_display(11 downto 8),digit3=>out_display(15 downto 12),clk=>clk,an=>an,cat=>cat);
component14: ID port map(clk=>clk,en=>en,instr=>instr,wd=>mux_wb,regWrite=>regWriteFinal,regDst=>regDst,extOp=>extOp,rd1=>out_rd1,rd2=>out_rd2,immExt=>immExt,func=>func,sa=>sa);
component15: EX port map(PC=>PC,rd1=>out_rd1,rd2=>out_rd2,immExt=>immExt,func=>func,sa=>sa,AluSrc=>AluSrc,AluOp=>AluOp,branchAddr=>branchAddr,AluRes=>AluRes, Zero=>zero, greaterThan0=>greaterThan0);
component16: MEM port map(clk=>clk,address=>AluRes,rd2=>out_rd2,memWrite=>memWriteFinal,memData=>memData,en=>en,AluRes=>AluRes);
process(clk)
begin
    if rising_edge(clk) then
        if en='1' then
            count_int<=count_int+1;
        end if;
   end if;
end process;

    zero1<= X"000" & sw(3 downto 0);
    zero2<= X"000" & sw(7 downto 4);
    zero3<= X"00" & sw(7 downto 0);
    
    suma<=zero1+zero2;
    scadere<=zero1-zero2;
    shiftst<=zero3(13 downto 0) & "00";
    shiftdr<="00" & zero3(15 downto 2);
    
    process(clk)
    begin
    if rising_edge(clk) then
        if en='1' then
            count<=count+1;
        end if;
    end if;
    end process;
    
    process(count,suma,scadere,shiftst,shiftdr)
    begin
    case count is
        when "00"=> out_mux2<=suma;
        when "01"=> out_mux2<=scadere;
        when "10"=> out_mux2<=shiftst;
        when others=> out_mux2<=shiftdr;
    end case;
    end process;
    
--    process(out_mux2)
--    begin
--    if(out_mux2=X"0000") then
--        led(7)<='1';
--    else 
--     led(7)<='0';
--    end if;
--    end process;

    --ROM
    process(clk)
    begin
        if rising_edge(clk) then
            if en='1' then
                count_rom<=count_rom+1;
            end if;
        end if;
    end process;
    
    do<=ROM(conv_integer(count_rom));
    
    --RF
    process(clk)
    begin
    if rising_edge(clk) then
        if en='1' then
            count_rf<=count_rf+1;
        end if;
    end if;
     if btn(2)='1' then
            count_rf<="000";
        end if;
    end process;
  
       suma_rf<=out_rd1+out_rd2;

    --RAM
    process(clk)
    begin
    if rising_edge(clk) then 
        if en='1' then
            count_ram<=count_ram+1;
        end if;
    end if;
    end process;
    shift_st<=do_ram(13 downto 0)&"00";
    
    --IFunit
     process(PC,instr)
     begin
     case sw(7 downto 5) is
         when "000"=> out_display<=instr;
        when "001"=> out_display<=PC;
        when "010"=> out_display<=out_rd1;
        when "011"=> out_display<=out_rd2;
        when "100"=> out_display<=AluRes;
        when "101"=>out_display<=memData;
        when "110"=>out_display<=immExt;
        when others=> out_display<=mux_wb;
     end case;
     end process;
     
     --UC
     process(instr(15 downto 13))
     begin
     regDst<='0';extOp<='0'; AluSrc<='0';Branch<='0';branchne<='0';branchGTZ<='0';
      Jump<='0';AluOp<="00"; memWrite<='0';memToReg<='0'; regWrite<='0';
      case instr(15 downto 13) is
        when "000"=> regDst<='1'; regWrite<='1'; AluOp<="10";
        when "001"=> regWrite<='1';AluSrc<='1';
        when "010"=> regWrite<='1';extOp<='1';AluSrc<='1'; memToReg<='1';
        when "100"=> extOp<='1';AluOp<="01";Branch<='1';
        when "101"=> extOp<='1';AluOp<="11";Branch<='1';branchGTZ<='1';
        when "110"=> extOp<='1';AluOp<="01";Branch<='1';branchne<='1';
        when others=> Jump<='1';
       end case;
     end process;
     
     regWriteFinal<=en and regWrite;
     led(0)<=regDst;
     led(1)<=regWrite;
     led(2)<=extOp;
     led(3)<=AluSrc;
     led(4)<=Branch;
     led(5)<=Jump;
     led(6)<=memWrite;
     led(7)<=memToReg;
     led(15 downto 14)<=AluOp;
     led(8)<=branchne;
     led(9)<=branchGTZ;
     led(13 downto 10)<="0000";
     
     
     process(memToReg)
     begin
     if memToReg='0' then
        mux_wb<=AluRes;
     else
        mux_wb<=memData;
     end if;
     end process;
    
    PcSrc<= (zero and Branch) or ((not(zero))and branchne) or (branchGTZ and greaterThan0);
    jmpAddr<= PC(15 downto 13) & instr(12 downto 0);
    memWriteFinal<=memWrite and en;
end Behavioral;
