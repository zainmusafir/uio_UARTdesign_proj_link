library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_rx is
    port(
       clk : in std_logic;
       rx  : in std_logic;
       baudrate : in std_logic;
       rx_complete : in std_logic;

       rx_data : out std_logic_vector(7 downto 0);
       rx_err : out std_logic :='0' 

    );

end entity;


architecture behv of shift_rx is 

signal rx_buffer : std_logic_vector(9 downto 0) := (Others => '0');
signal baudrate_enable : std_logic;
signal baudrate_r : std_logic;



begin


process(clk)
  begin
    if rising_edge(clk) then
	   baudrate_r <= baudrate;
	 
      if baudrate_enable = '1' then  --rising enable pulse that samples received bits almost after half of baud cycle
        rx_buffer <= rx & rx_buffer(9 downto 1);
      end if;
    


      if (rx_complete ='1')  then   --8 bit data output of the receiver to the processor
         rx_data <= rx_buffer(8 downto 1);
			rx_err <= not rx_buffer(9) or rx_buffer(0);
      end if;
		


      
    end if;

  end process;

  
  baudrate_enable <= not baudrate_r  and baudrate; 


end behv;
