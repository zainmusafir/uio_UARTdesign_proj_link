library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tx_fsm is
    Port ( 
    
    clk :          in std_logic;
    areset_n :     in std_logic;  --high always low on reset used to reset the machine and the counter 
    tx_data_valid: in std_logic;
    tx_complete  : in std_logic;

    tx_enable: out std_logic; --output to drive baudrate gen and others
    tx_busy: out std_logic
    
    );
	 
	 end tx_fsm;

   architecture behavioral of tx_fsm is

        type state_type is (Sidle, Stransmit);
        signal state : state_type;

     begin

    process(clk)
	      begin
      

        if rising_edge(clk) then

            if areset_n = '0' then
            state <= Sidle;
            end if;

           
            case state is
                when Sidle =>
                    if tx_data_valid  = '1' then
                        state <= Stransmit;
                    end if;

                when Stransmit =>
                    tx_busy <= '1';
                    tx_enable <= '1';

                    if tx_complete = '1' then
                        state <= Sidle;

                    end if;
                    
                when others =>
                    state <= Sidle;
            end case;
        end if;

    end process;

end architecture;