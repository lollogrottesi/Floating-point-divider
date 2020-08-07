----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.07.2020 14:32:28
-- Design Name: 
-- Module Name: SRT_divider - Behavioral
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

entity SRT_divider is
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
end SRT_divider;

architecture Behavioral of SRT_divider is

component c_l_addr IS
    generic (N: integer:= 25);
    PORT
        (
         x_in      :  IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         y_in      :  IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         carry_in  :  IN   STD_LOGIC;
         sum       :  OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         carry_out :  OUT  STD_LOGIC
        );
END component;

type statetype is (reset, idle, compute, check_sign ,final_state);
signal c_state, n_state: statetype;
signal c_rmd, n_rmd: std_logic_vector(N-1 downto 0);
signal c_q, n_q, c_cnt, n_cnt: std_logic_vector(D_length-1 downto 0);
signal c_shift_rmd, n_shift_rmd, n_norma_shift_rmd: std_logic_vector(N-1 downto 0);
signal decision_bits: std_logic_vector(1 downto 0);
signal acc_q: std_logic_vector(D_length-1 downto 0);
signal template_add_bit, template_sub_bit: std_logic_vector(D_length-1 downto 0);
signal add_sub_rmd, add_sub_quo: std_logic;
signal xor_net_rmd: std_logic_vector(N-1 downto 0);
signal xor_net_quo: std_logic_vector(D_length-1 downto 0);
signal sum_divider_addr_in: std_logic_vector(N-1 downto 0);
signal sum_divider: std_logic_vector(N-1 downto 0);

signal carry: std_logic_vector(1 downto 0);
signal rmd_sum: std_logic_vector(N-1 downto 0);
signal quo_sum: std_logic_vector(D_length-1 downto 0);
begin
rmd_addr: c_l_addr generic map(N)
                   port map (c_shift_rmd, sum_divider_addr_in, add_sub_rmd, rmd_sum, carry(0));
quotinet_addr: c_l_addr generic map(D_length)
                   port map (c_q, acc_q, '0', quo_sum, carry(1));         
                             
xor_net_rmd <= (others=>add_sub_rmd);
                                             
decision_bits <= c_shift_rmd(N-1)&c_shift_rmd(N-2);

template_add_bit(D_length-1 downto D_length-2) <= "01";
template_add_bit(D_length-3 downto 0) <= (others =>'0');

template_sub_bit (D_length-1 downto D_length-2) <= "11";
template_sub_bit (D_length-3 downto 0) <= (others =>'0');

sum_divider(N-1 downto N-D_length) <= divider;
sum_divider(N-D_length-1 downto 0) <= (others =>'0');
sum_divider_addr_in <=  sum_divider xor xor_net_rmd;
    process(clk)
    begin
        if (clk = '1' and clk' event) then
            if (rst = '1') then
                c_state <= reset;
                c_cnt <= (others=>'0');
                c_q <= (others=>'0');
                c_shift_rmd <= (others=>'0');
            else
                c_state <= n_state;
                c_rmd <= n_rmd;
                c_q <= n_q;
                c_shift_rmd <= n_shift_rmd;
                c_cnt <= n_cnt;
            end if;
        end if;
    end process;
    
    process(c_state, dividend, divider, c_q, c_rmd, c_cnt, soa, c_shift_rmd, decision_bits, rmd_sum, quo_sum) --c_acc_q deleted.
    begin
        case c_state is
            when reset=>
                eoa <= '0';
                busy <= '0';
                n_state <= idle;
                n_q <= c_q;
                n_rmd <= c_rmd;
                n_cnt <= c_cnt;
                n_shift_rmd <= c_shift_rmd;
            when idle=>
                eoa <= '0';
                busy <= '0';
                n_q <= (others=>'0');
                n_cnt <= (others=>'0');
                if (soa = '1') then
                    n_rmd <= dividend;
                    n_shift_rmd <= std_logic_vector(shift_left(unsigned(dividend), 1));
                    n_state <= compute;
                else
                    n_rmd <= (others=>'0');
                    n_shift_rmd <= (others=>'0');
                    n_state <= idle;
                end if;     
            when compute=>
                eoa <= '0';
                busy <= '1';
                if (unsigned (c_cnt) < D_length-2) then
                    n_cnt <= std_logic_vector(unsigned(c_cnt) + 1);
                    n_state <= compute;
                else
                    n_cnt <= (others =>'0'); 
                    n_state <= final_state;
                end if;
                
                
                --Sign&MSB case
                --00=> c_rmd <0.5
                --01=> c_rmd >= 0.5
                --10=> c_rmd <=-0.5
                --11=> c_rmd >-0.5
                 if (decision_bits = "00") then
                    --when "00"=>
                    n_rmd <= c_shift_rmd;
                    n_shift_rmd <= std_logic_vector(shift_left(unsigned(c_shift_rmd), 1));
                    n_q <= quo_sum;
                    acc_q <= (others => '0');
                 elsif (decision_bits = "01") then      
                    --when "01"=>
                    acc_q <= std_logic_vector(shift_right(unsigned(template_add_bit), to_integer(unsigned(c_cnt))));
                    n_q <= quo_sum;
                    add_sub_rmd <= '1'; --sub rmd.
                    n_rmd <= rmd_sum;
                    n_shift_rmd <= std_logic_vector(shift_left(unsigned(rmd_sum), 1));
                    
                 elsif (decision_bits = "10") then                 
                    --when "10"=>
                    add_sub_rmd <= '0'; --sub rmd.
                    n_rmd <= rmd_sum;
                    n_shift_rmd <= std_logic_vector(shift_left(unsigned(rmd_sum), 1));
                    n_q <= quo_sum;
                    acc_q <= std_logic_vector(shift_right(signed(template_sub_bit), (to_integer(unsigned(c_cnt))))); 
                  elsif (decision_bits = "11") then    
                    --when "11"=>
                    n_rmd <= c_shift_rmd;
                    n_shift_rmd <= std_logic_vector(shift_left(unsigned(c_shift_rmd), 1));
                  end if;
                
            when check_sign=>
               if (c_rmd(N-1) = '1') then
                    n_rmd(N-1 downto N-D_length) <= std_logic_vector(unsigned(c_rmd(N-1 downto N-D_length)) + unsigned(sum_divider(N-1 downto N-D_length)));
                    n_q <= std_logic_vector(unsigned(c_q) - 1);
               else
                    n_rmd <= c_rmd;
                    n_q <= c_q;
               end if;
               
               eoa <= '0';
               busy <= '1';
               n_state <= final_state;
               n_cnt <= (others=>'0');
               n_shift_rmd <= (others=>'0');
            when final_state=>  
               eoa <= '1';
               busy <= '1';
               n_state <= idle;
               n_cnt <= (others=>'0');
               n_shift_rmd <= (others=>'0');          
        end case;
            
    end process;
quotient <= c_q;
reminder <= c_rmd(N-1 downto N-D_length);
end Behavioral;
