library ieee;
use ieee.std_logic_1164.all;


entity baud_rate_generator_tb is
end entity;


architecture tb of baud_rate_generator_tb is 
       
        signal clk_ena: boolean := false;
        signal clk: std_logic;

        constant clk_p: time := 20 ns;
       
        signal tx_enable: std_logic;
     

begin

dut: entity work.baud_rate_generator
port map(
        clk => clk,
        tx_enable => tx_enable,
        baudrate => baudrate 
        );

--Create clk:
        clk <= not clk after clk_period/2 when clk_en else '0';

        p_stimuli: Process
        begin
        
        
        tx_enable <= '1';
       
        clk_enable <= true;
        tx_enable <= '0';
        wait for 500*clk_period; 

        tx_enable <= '0';
        wait for 1000*clk_period; 
             
        clk_enable <= false;         

wait;

end process;
end architecture;