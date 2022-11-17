library ieee;
use ieee.std_logic_1164.all;

entity shift_tx is

  generic (
     n  : integer := 8 
    );

  port(
    baudrate:         in std_logic; 
    clk:              in std_logic; 
    tx_data_valid:    in std_logic;    --enables shifting
	 
    tx_data:      in std_logic_vector(n-1 downto 0);    --tx data   --parallel in   
    tx_i:         out std_logic   --serial output
    );
end shift_tx;




architecture behavioral of shift_tx is

   

  signal temp_reg: std_logic_vector(9 downto 0) := (Others => '0');
  
  signal baudrate_r : std_logic;
  signal baudrate_enable : std_logic;
  

begin


  process (clk)
  
  begin
  
  

		
	 if(rising_edge(clk)) then 
	     baudrate_r <= baudrate;
		  
		  
		  
	   if (tx_data_valid = '1') then
       temp_reg <= '1' & tx_data & '0' ; 
      end if;  
      
		
		if(baudrate_enable = '1') then     
        --shifting n number of bits
      temp_reg <= '1' & temp_reg(9 downto 1);  --one and register
        
      
      end if;
		    
    end if;
	 
 
  end process;
  
  
  baudrate_enable <= not baudrate and baudrate_r;   -- that d flip flop thingy that generates proper baud pulses to be detected 
  
  
  tx_i <= temp_reg(0);
  
  
  
end behavioral;