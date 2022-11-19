library IEEE;
use IEEE.STD_LOGIC_1164.ALL;




entity UART_tx is

  generic (
     n  : integer := 8 
    );
	 
	port (
	 
	 clk : in std_logic;
	 areset_n : in std_logic;
	 
	 tx_data_valid : in std_logic;
	 tx_data : in std_logic_vector(7 downto 0);
	 
	 
	 
	 
	 tx : out std_logic;
	 tx_busy : out std_logic
	 );
	
	end UART_tx;
	
architecture mixed of UART_tx is 

--signals and components



component baudrategen is

Port (     clk :      in  STD_LOGIC;
           tx_enable: in STD_LOGIC;
           baudrate : out STD_LOGIC
           --baud2   : out STD_LOGIC
			  );
end component;

component bitcounter is
    Port ( baudrate: in std_logic; 
           clk: in std_logic; 
			  areset_n: in std_logic;    --input to reset the counter
           tx_complete: out std_logic
           --counter: out std_logic 
     );
end component;

component shift_tx is

port(
    baudrate:         in std_logic; 
    clk     :         in std_logic; 
    tx_data_valid:    in std_logic;    --enables shifting
    tx_data:      in std_logic_vector(n-1 downto 0);    --tx data   --parallel in
    
    tx_i:         out std_logic   --serial output
    );
end component;

component tx_fsm is
    Port ( 
    
    clk :          in std_logic;
    areset_n :     in std_logic;  --high always low on reset used to reset the machine and the counter 
    tx_data_valid: in std_logic;
    tx_complete  : in std_logic;

    tx_enable: out std_logic; --output to drive baudrate gen and others
    tx_busy: out std_logic
    
    );
	 
	 end component;
	
	
	signal tx_complete : std_logic;
	signal tx_enable : std_logic;
	signal baudrate : std_logic;
	signal tx_i : std_logic;
	

	begin

	
	
	statemachine: tx_fsm
	
	port map( clk=>clk, 
	     areset_n=>areset_n, 
		  tx_data_valid => tx_data_valid,
		  
		  
		  tx_complete => tx_complete,
		  tx_busy => tx_busy) ;
	
	
	
	baudrategenerator : baudrategen
	
	 port map( clk=>clk,
           tx_enable=> tx_enable,
           baudrate=> baudrate );
			  
			  
			  
   shiftregister : shift_tx
	
	port map(
	
    baudrate => baudrate,     
    clk => clk,          
    tx_data_valid=> tx_data_valid,   
    tx_data=>tx_data,      
    tx_i=> tx_i
     
    );
			  
			  
	      
	     
	
   process(clk)
	
	begin 
	
	if (rising_edge(clk)) then
	 
	    if(tx_enable = '1') then
		    tx <=tx_i;
			 
		 else 
		    tx<='1';
	    end if;
	end if;
	
	end process;




	end mixed;	
