----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2025 05:31:23 PM
-- Design Name: 
-- Module Name: instr_decode - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instr_decode is
    Port ( instr: in STD_LOGIC_VECTOR(15 downto 0);
           wd: in STD_LOGIC_VECTOR(15 downto 0);
           clk: in STD_LOGIC;
           reg_write: in STD_LOGIC;
           reg_dst: in STD_LOGIC;
           ext_op: in STD_LOGIC;
           
           rd1: out STD_LOGIC_VECTOR(15 downto 0);
           rd2: out STD_LOGIC_VECTOR(15 downto 0);
           ext_imm: out STD_LOGIC_VECTOR(15 downto 0);
           func: out STD_LOGIC_VECTOR(2 downto 0);
           sa: out STD_LOGIC
    );
end instr_decode;

architecture Behavioral of instr_decode is

component reg_file is 
port ( clk: in std_logic; 
       ra1: in std_logic_vector (2 downto 0);  
       ra2: in std_logic_vector (2 downto 0);  
       wa: in std_logic_vector (2 downto 0); 
       wd: in std_logic_vector (15 downto 0); 
       wen: in std_logic; 
       rd1: out std_logic_vector (15 downto 0);  
       rd2: out std_logic_vector (15 downto 0) 
); 
end component; 

signal wa_aux: std_logic_vector (2 downto 0);

begin

regfile: reg_file port map(clk, instr(12 downto 10), instr(9 downto 7), wa_aux, wd, reg_write, rd1, rd2); 

mux: process(instr, reg_dst)
     begin
        if(reg_dst = '1') then
            wa_aux <= instr(6 downto 4);
        else
            wa_aux <= instr(9 downto 7);
        end if;
     end process;
     
ext_unit: process(instr, ext_op)
          begin
            if (ext_op = '0' or instr(6) = '0') then
                ext_imm <= ("000000000" & instr(6 downto 0));
            else
                ext_imm <= ("111111111" & instr(6 downto 0));
            end if;
          end process;

func <= instr(2 downto 0);
sa <= instr(3);

end Behavioral;
