library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_rx is

	port (
	 clk : in std_logic;
	 areset_n : in std_logic;
	 rx : in std_logic;
	 
	 rx_data : out std_logic_vector(7 downto 0);
	 rx_err:   out  std_logic;
	 rx_busy : out std_logic
	
	 );
	
	end UART_rx;
	
architecture mixed of UART_rx is 

signal baudrate: std_logic;
signal rx_complete : std_logic;
signal rx_enable : std_logic;
	
--signals and components

  component rx_fsm is
    Port ( 
    
    clk :  in std_logic;   
    rx   : in std_logic;
    
    rx_complete : in std_logic;
	 rx_enable : out std_logic;

    rx_err : out std_logic;
    rx_busy: out std_logic

    );
	 
	 end component;
	 
	 
	component baudrategen_rx is
    Port ( clk :      in  STD_LOGIC;
           rx_enable: in STD_LOGIC;
           baudrate : out STD_LOGIC
           --baud2   : out STD_LOGIC
			  );
	end component ;
	
	component bitcounter_rx is
    Port ( baudrate: in std_logic; 
           clk: in std_logic; 
		     areset_n: in std_logic;    --input to reset the counter
           rx_complete: out std_logic
           --counter: out std_logic 
     );
	end component;
	
	component shift_rx is
    port(
       clk : in std_logic;
       rx  : in std_logic;
       baudrate : in std_logic;
       rx_complete : in std_logic;

       rx_data : out std_logic_vector(7 downto 0);
       rx_err : out std_logic

    );
	 
	 end component;
	 

	begin
	
statemachinerx :rx_fsm

	port map ( clk =>clk,
    
    rx => rx,
    rx_complete =>rx_complete,
	 rx_enable =>rx_enable,

    rx_busy=> rx_busy);
			  
baudrategeneratorrx : baudrategen_rx			  

    Port map ( clk=> clk,
           rx_enable=> rx_enable,
           baudrate => baudrate);	 
	 
bitcounterrx : bitcounter_rx 
	 port map(	baudrate=> baudrate,
           clk=> clk,
		     areset_n=> areset_n,
           rx_complete=> rx_complete);

shiftregisterrx : shift_rx

     port map(
	  
	  clk => clk,
       rx  => rx,
       baudrate => baudrate,
       rx_complete => rx_complete,

       rx_data => rx_data,
       rx_err=> rx_err
		 );
	  
	
	

 




	end mixed;	
