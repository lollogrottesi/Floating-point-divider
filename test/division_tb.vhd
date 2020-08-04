----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.07.2020 17:38:22
-- Design Name: 
-- Module Name: division_tb - Behavioral
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

entity division_tb is
--  Port ( );
end division_tb;

architecture Behavioral of division_tb is

component IEEE_754_Divider_unit is
    port (FP_a: in std_logic_vector(31 downto 0);--Normalized  biased values.
          FP_b: in std_logic_vector(31 downto 0);
          clk : in std_logic;
          rst : in std_logic;
          soa : in std_logic;
          eoa : out std_logic;
          error: out std_logic;
          FP_z: out std_logic_vector(31 downto 0));
end component;
signal a, b, z: std_logic_vector(31 downto 0);
signal clk, rst, soa, eoa, error: std_logic;

begin
dut: IEEE_754_Divider_unit port map (a, b, clk, rst, soa, eoa, error,  z);
    process
    begin
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
    end process;
    
    process
    begin
        rst <= '1';
        wait until clk = '1' and clk'event;
        rst <= '0';
        wait until clk = '1' and clk'event;
       
        a <=  x"c0100000";
        b <=  x"c0100000";
        soa <= '1'; 
        wait until clk = '1' and clk'event;
        soa <= '0'; 
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait until clk = '1' and clk'event;
        wait;
    end process;
end Behavioral;
