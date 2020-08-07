----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.07.2020 17:10:01
-- Design Name: 
-- Module Name: Mantissa_divider - Behavioral
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

entity Mantissa_divider is
    --The sum is perfomed in 26 bits, 1 bit sign + 1 guardian bit +implicit 1 before mantissa + 23 bit matissa = 26 bit.
    --The rapresentation is sign magnitude so conversion to two's complement could be necessary.
    Port (M_a: in std_logic_vector(25 downto 0);
          M_b: in std_logic_vector(24 downto 0);
          soa: in std_logic;
          clk: in std_logic;
          rst: in std_logic;
          M_out: out std_logic_vector(24 downto 0);
          busy: out std_logic;
          eoa: out std_logic);
end Mantissa_divider;

architecture Behavioral of Mantissa_divider is
component SRT_divider is
    generic (N: integer:= 32;           --Length of the dividend.
             D_length: integer:= 5);    --Length of the divider, (the two lengths are different due the normalization factors).
    port (dividend: in std_logic_vector(N-1 downto 0);
          divider:  in std_logic_vector(D_length-1 downto 0);
          clk, rst: in std_logic;
          soa:      in std_logic;
          busy:     out std_logic;
          eoa:      out std_logic; 
          quotient: out std_logic_vector(D_length-1 downto 0);
          reminder: out std_logic_vector(D_length-1 downto 0));
end component;

signal rmd: std_logic_vector(24 downto 0);
begin
divider_unit: SRT_divider generic map (26, 25)
                          port map(M_a, M_b, clk, rst, soa, busy, eoa, M_out, rmd);

end Behavioral;
