library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity rx_fsm is
    Port ( 
    
    clk :   in std_logic;
    areset_n :     in std_logic;
    rx   : in std_logic;
    
    rx_complete : in std_logic;
	 rx_enable : out std_logic;

    rx_err : out std_logic;
    rx_busy: out std_logic

    );
	 
end rx_fsm;

architecture behavioral of rx_fsm is

        type state_type is (Sidle, Sreceive);
        signal state : state_type; 
    
     
        begin

        p_state : process(clk) is

		  
		  begin

        if (rising_edge(clk)) then
		  
		  
		   if  areset_n='0' then 
			state <= Sidle;
			end if;
			
		  
			if(rx='0') then
            state<= Sreceive;
			end if;
			
			
            case state is
                when Sidle => 
                   rx_busy <= '0';
						 rx_enable <= '0';
						 
						 if(rx='0') then
                   state<= Sreceive;
						  
                  end if;
          
                when Sreceive =>
                   
						  rx_enable <= '1';
						 
                  if rx_complete  = '1' then
                    state <= Sidle;
						  
                  end if;
                when others =>
					   state <= Sidle;
					 
            end case;
        
        end if;   
         
        

        end process p_state;

end behavioral;        

                



