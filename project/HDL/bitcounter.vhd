library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
  
entity bitcounter is
    Port ( baudrate: in std_logic; 
           clk: in std_logic; 
		   areset_n: in std_logic;    --input to reset the counter
           tx_complete: out std_logic
           --counter: out std_logic 
     );
end bitcounter;

architecture Behavioral of bitcounter is

signal counter_up: integer range 0 to 20 :=0;
signal baudrate_r : std_logic;   --baudraate taken into register in the clk process and towards the d ff and and gate
signal baudrate_enable : std_logic;

 begin
-- up counter
process(clk)

  begin

 if(rising_edge(clk)) then

    if(baudrate_enable ='1') then   --checking for baud pulse and counting,

        tx_complete<='0';
        counter_up <= counter_up + 1;

    end if;
    
	 
	 
	 if( areset_n= '0') then 
		counter_up <= 0;
	 end if;
	 
	 if (counter_up= 10) then
	 
		counter_up <= 0;
		tx_complete <= '1';	
    end if;
	 
	 
 end if;

end process; 
	 
        baudrate_r <= baudrate;
		  baudrate_enable<= not baudrate and baudrate_r;   -- that d flip flop thingy that generates proper baud pulses to be detected
     


end Behavioral;