----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2025 08:42:42 AM
-- Design Name: 
-- Module Name: data_memory - Behavioral
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_memory is
    Port ( clk : in std_logic; 
           mem_write : in std_logic; 
           ALURes : in std_logic_vector(15 downto 0); 
           rd2 : in std_logic_vector(15 downto 0); 
           MemtoReg: in STD_LOGIC;
           
           mem_data : out std_logic_vector(15 downto 0); 
           --ALURes_out : out std_logic_vector(15 downto 0);
           WD: out std_logic_vector(15 downto 0)
            );
end data_memory;

architecture Behavioral of data_memory is

type ram_type is array (0 to 127) of std_logic_vector (15 downto 0); 
signal RAM: ram_type; 
signal mem_data_aux: std_logic_vector(15 downto 0);

begin 
 
process(clk, ALURes, rd2, mem_write) 
begin 
if rising_edge(clk) then 
    if mem_write = '1' then 
        RAM(conv_integer(ALURes)) <= rd2; 
    end if; 
end if; 
end process;

mem_data_aux <= RAM(conv_integer(ALURes));
mem_data <= mem_data_aux;

WB: process(MemtoReg, ALURes, mem_data_aux)
begin
    if MemtoReg = '1' then
        WD <= mem_data_aux;
    else
        WD <= ALURes;
    end if;
end process;

--ALURes_out <= ALURes_in;

end Behavioral;
