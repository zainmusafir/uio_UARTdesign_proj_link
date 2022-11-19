library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity baudrategen is
    Port ( clk :      in  STD_LOGIC;
           tx_enable: in STD_LOGIC;
           baudrate : out STD_LOGIC
           --baud2   : out STD_LOGIC
			  );
end baudrategen;

architecture Behavioral of baudrategen is

constant max : integer := 434 ;  
signal count : integer range 0 to max :=0;


begin
    -- clock divider
    process (clk)
	 
    begin
      if (tx_enable='0') then
        baudrate <= '0';
      

      else
      
        if (rising_edge(clk)) then   --rising edge
            count <= count+1;
        end if;

        if(count< max/2 )then
            baudrate <='0';
        else 
            baudrate <= '1';
        end if;
        
        if(count = max-1)then
            count <= 0;
        end if;

      
        
      end if ;  
    end process;
    
   
    
end Behavioral;