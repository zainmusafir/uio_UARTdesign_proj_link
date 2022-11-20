
library ieee;
use ieee.std_logic_1164.all;

entity uart is
    generic (
        GC_SYSTEM_CLK : integer := 50_000_000;
        GC_BAUD_RATE  : integer := 115_200
    );
	 
	 
  port(
    clk          : in std_logic;
    arst_n       : in std_logic;
    rx           : in std_logic;
    tx           : out std_logic;
	 
    we           : in std_logic;
    re           : in std_logic;
    wdata        : in std_logic_vector (31 downto 0);
    rdata        : out std_logic_vector (31 downto 0);
    addr         : in std_logic_vector (1 downto 0);
 
    irq          : out std_logic
  );
end entity;



architecture mixed of uart is
    
	 
    signal rx_data         : std_logic_vector (7 downto 0);
	 
	 
    signal mm_tx_data      : std_logic_vector(7 downto 0); 
    signal mm_rx_data      : std_logic_vector(7 downto 0); 
	 
    signal mm_tx_status    : std_logic_vector(7 downto 0) := "00000000";
   
    signal tx_busy         : std_logic;
    signal rx_busy         : std_logic;
    signal rx_err          : std_logic;
  
    signal areset_n :  std_logic;
	 signal tx_data_valid :  std_logic;
	 signal tx_data :  std_logic_vector(7 downto 0);

component UART_rx is
    port (
        clk : in std_logic;
        areset_n : in std_logic;
		  
		  
        rx_data : out std_logic_vector (7 downto 0);
        rx_err : out std_logic;
        rx_busy : out std_logic;
        rx : in std_logic 
    
    );
    end component;

component UART_tx is

 	port (
	 
	 clk : in std_logic;
	 areset_n : in std_logic;
	 
	 tx_data_valid : in std_logic;
	 tx_data : in std_logic_vector(7 downto 0);
	 
	 
	 
	 
	 tx : out std_logic;
	 tx_busy : out std_logic
	 );
    end component;

begin

transmitter : UART_tx

 port map(
 clk => clk,
tx_data_valid => tx_data_valid,
areset_n => areset_n,


tx_data => tx_data,
tx_busy => tx_busy,
tx => tx
);



receiver : UART_rx

 port map
 
 (clk => clk,
areset_n => areset_n,
rx_data => rx_data,
rx_err => rx_err,
rx_busy => rx_busy,
rx => rx);



  youaart : process(arst_n, clk)
  
    begin
      if arst_n = '0' then
        mm_tx_data <= (others => '0');
        mm_rx_data <= (others => '0');
        mm_tx_status <= (others => '0');
		  
		  
		  --all zero when reset
		  
       
      elsif rising_edge(clk) then
		
		
        if tx_busy='1' and mm_tx_status(1)='0' then  --tx_busy and txbusy status bit
            mm_tx_status(0) <='0'; --txdatavalid
        end if;
		  
        
        if mm_tx_status(1)='1' and tx_busy='0' then
            mm_tx_status(4) <= '1';     --txirq
				
        end if;
		  
		  
        
        if mm_tx_status(2)='1' and rx_busy='0' then
            mm_tx_status(5) <='1';   --rxirq
            mm_rx_data <= rx_data;
        end if;
        
		  
		  
        if we = '1' then 
          case addr is
            when "00" =>  
              mm_tx_data <= wdata (7 downto 0);
              mm_tx_status(0)<='1';
				  
            when "10" =>  
              mm_tx_status(5) <= '0';  --rxirq
              mm_tx_status(4) <= '0';  --txirq
            when others =>
				 null;
          end case;
        end if;
        
        if re = '1' then 
          case addr is
            when "01" =>
              rdata <= x"000000" & mm_rx_data; 
            
            when others =>
              rdata <= x"00000000"; 
				 
          end case;
        end if;
      
      mm_tx_status(1) <= tx_busy;  --txbusybit
      mm_tx_status(2) <= rx_busy;   -- rxbusybit
      mm_tx_status(3) <= rx_err;   --error bit
    end if; 
  end process;


irq <= mm_tx_status(4) or mm_tx_status(5);  --txirq ord with rx irq interrupt to processor


end architecture mixed;
