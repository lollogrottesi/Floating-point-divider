----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.07.2020 17:05:30
-- Design Name: 
-- Module Name: Exponent_subctrator - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Exponent_subctrator is
    port(E_a: in std_logic_vector(7 downto 0);
         E_b: in std_logic_vector(7 downto 0);
         E_out: out std_logic_vector(7 downto 0));
end Exponent_subctrator;

architecture Behavioral of Exponent_subctrator is

begin
E_out <= std_logic_vector(unsigned(E_a) - unsigned(E_b) + 127);

end Behavioral;
