----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2025 01:23:07 PM
-- Design Name: 
-- Module Name: instr_fetch - Behavioral
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

entity instr_fetch is
    Port ( jmp_addr: in STD_LOGIC_VECTOR(15 downto 0);
           branch_addr : in STD_LOGIC_VECTOR(15 downto 0);
           PCSrc : in STD_LOGIC;
           PCSrcNE: in STD_LOGIC;
           jump_en: in STD_LOGIC;
           clk: in STD_LOGIC;
           mpg_en: in STD_LOGIC;    
           instruction : out STD_LOGIC_VECTOR(15 downto 0);
           pc_incremented: out STD_LOGIC_VECTOR(15 downto 0)
          
    );
end instr_fetch;

architecture Behavioral of instr_fetch is

signal pc_in, pc_out: std_logic_vector(15 downto 0) := x"0000";

type reg_array is array (0 to 255) of std_logic_vector(15 downto 0); 
signal rom: reg_array:= (
    B"001_010_011_0000_111", -- ADDI reg3 := reg2 + 7
    B"001_011_001_0000_010", -- ADDI reg1 := reg3 + 2
    B"000_011_001_111_0_000", -- ADD reg7 := reg3 + reg1
    B"000_111_000_101_1_010", -- SLL reg5 := reg7 << 1
    B"000_111_000_100_1_011", -- SRL reg4 := reg7 >> 1
    B"000_001_011_110_0_001", -- SUB reg6 := reg1 - reg3
    B"000_111_110_011_0_100", -- SRLV reg3 := reg7 >> reg6
    B"001_101_000_0000_110", -- ADDI reg0 := reg5 + 6
    B"001_101_110_0000_011", -- ADDI reg6 := reg5 + 3
    B"000_000_110_001_0_101", -- AND reg1 := reg0 and reg6
    B"111_0000_0000_0111_1", -- JUMP PC := 15
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"001_111_010_0000_001", -- ADDI reg2 := reg7 + 1
    B"000_001_010_011_0_110", -- OR reg3 := reg1 or reg2
    B"010_000_010_0011_011", -- XORI reg2 := reg0 xor 0011011
    B"100_011_010_0000_000", -- SW mem[r3 + 0] := r2
    B"011_110_101_0010_000", -- LW r5 := mem[r6 + 16]
    B"000_110_101_000_0_111", -- XOR r0 := r6 xor r5
    B"001_010_001_0000_000", -- ADDI reg1 := reg2 + 0
    B"101_001_011_0000_011", -- BEQ if reg1 == reg3:  pc := pc+3
    B"101_001_010_0000_011", -- BEQ if reg1 == reg2:  pc := pc+3
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_001_000_101_1_010", -- SLL  reg5 := reg1 << 1
    B"110_001_010_0000_111", -- BNE if reg1 != reg2: pc := pc + 7
    B"110_001_011_0000_010", -- BNE if reg1 != reg3: pc := pc + 2
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_001_000_101_1_011", -- SRL  reg5 := reg1 >> 1
        
    others => x"0000"
); 

begin

PC: PROCESS(CLK, mpg_en)
    BEGIN
    IF (RISING_EDGE(CLK) and mpg_en = '1') THEN 
        pc_out <= pc_in;    
    END IF;
    END PROCESS;
    
Instr_Mem: process(pc_out)
           begin
               instruction <= rom(conv_integer(pc_out(7 downto 0)));
           end process;

mux: process(pc_out, branch_addr, PCSrc, PCSrcNE, jmp_addr, jump_en)
     begin
        if jump_en = '1' then
            pc_in <= jmp_addr;
        elsif PCSrc = '1' then
            pc_in <= branch_addr;
        elsif PCSrcNE = '1' then
            pc_in <= branch_addr;
        else
            pc_in <= pc_out + 1;
        end if;
     end process;

pc_incremented <= pc_out + 1;

end Behavioral;
