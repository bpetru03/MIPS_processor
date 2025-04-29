----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2025 06:55:18 PM
-- Design Name: 
-- Module Name: execute_unit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--USE IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity execute_unit is
    Port ( next_addr: in STD_LOGIC_VECTOR(15 downto 0);
           rd1: in STD_LOGIC_VECTOR(15 downto 0);
           rd2: in STD_LOGIC_VECTOR(15 downto 0);
           ext_imm: in STD_LOGIC_VECTOR(15 downto 0);
           func: in STD_LOGIC_VECTOR(2 downto 0);
           sa: in STD_LOGIC;
           ALUSrc: in STD_LOGIC;
           ALUOp: in STD_LOGIC_VECTOR(1 downto 0);
            
           branch_address: out STD_LOGIC_VECTOR(15 downto 0);
           ALURes: out STD_LOGIC_VECTOR(15 downto 0);
           zero: out STD_LOGIC
    );
end execute_unit;

architecture Behavioral of execute_unit is

signal ALURes_aux: STD_LOGIC_VECTOR(15 downto 0);
signal second_operand: STD_LOGIC_VECTOR(15 downto 0);

begin
ALURes <= ALURes_aux;

mux:process(rd2, ext_imm, ALUSrc)
    begin
    if ALUSrc = '0' then
        second_operand <= rd2;
    else
        second_operand <= ext_imm;
    end if;    
    end process;

ALU: process(rd1, second_operand, sa, func, ALUOp)
     begin
     case ALUOp is
         when "00" =>
             case func is
                when "000" => ALURes_aux <= rd1 + second_operand;
                when "001" => ALURes_aux <= rd1 - second_operand;
                when "010" => 
                    if sa = '1' then
                        ALURes_aux <= std_logic_vector(shift_left(unsigned(rd1), 1));
                    end if;
                when "011" =>
                    if sa = '1' then
                        ALURes_aux <= std_logic_vector(shift_right(unsigned(rd1), 1));
                    end if;
                when "100" => ALURes_aux <= std_logic_vector(shift_right(unsigned(rd1), conv_integer(second_operand)));
                when "101" => ALURes_aux <= rd1 and second_operand;
                when "110" => ALURes_aux <= rd1 or second_operand;
                when "111" => ALURes_aux <= rd1 xor second_operand;
             end case;   
         when "01" =>
             ALURes_aux <= rd1 + second_operand;
         when "10" =>
             ALURes_aux <= rd1 xor second_operand;
         when "11" =>
             ALURes_aux <= rd1 - second_operand;
     end case;
     end process;
     
Z_flag: process(ALURes_aux)
        begin
            if ALURes_aux = x"0000" then
                zero <= '1';
            else
                zero <= '0';
            end if;
        end process;

branch_address <= next_addr + ext_imm; -- check if correct


end Behavioral;
