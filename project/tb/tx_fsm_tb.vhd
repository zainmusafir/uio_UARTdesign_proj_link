library ieee;
use ieee.std_logic_1164.all;

entity tx_fsm_tb is
end entity;

architecture tb of tx_fsm_tb is

    
    signal clk_ena      : boolean   := false;
    signal clk          : std_logic := '0';
    constant clk_period : time      := 20 ns;

    
    signal areset_n     : std_logic := '1';
    signal tx_data_valid: std_logic := '0';
    signal tx_complete  : std_logic := '0';


    signal tx_busy      : std_logic;
    signal tx_enable    : std_logic;

begin
   
    clk <= not clk after clk_period/2 when clk_ena else '0';
    
    TX_FSM: entity work.tx_fsm(behavioral)
      port map(
        clk => clk,
        tx_data_valid => tx_data_valid,
        tx_complete => tx_complete,
        areset_n => areset_n,



        tx_busy => tx_busy,
        tx_enable => tx_enable
      );
 
    p_stimuli : process
    begin
        clk_ena <= true;
        
        
        tx_data_valid <= '1';
        wait for 50 ns;
        
        tx_data_valid <= '0';
       
        tx_complete   <= '1';
        wait for 50 ns;
        tx_complete   <= '0';

        
        tx_data_valid <= '1';
        wait for 50 ns;

        tx_data_valid <= '0';
        wait for 50 ns;

        areset_n <= '0';
        wait for 150 ns;

        clk_ena <= false;
        wait;
    end process;

end architecture;