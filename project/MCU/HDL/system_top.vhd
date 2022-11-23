library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;

entity system_top is
  port (
         clk : in  std_logic := 'X';             -- clk
			
			irq : in  std_logic_vector(2 downto 0) := (others => 'X'); -- export
			led : out std_logic_vector(9 downto 0);                    -- export
			sw  : in  std_logic_vector(9 downto 0) := (others => 'X'); -- export
			arst_n : in  std_logic                    := 'X';
			
			tx  : out std_logic;                                       -- tx
			rx  : in  std_logic:= 'X';             -- rx
			
			MISO       : in  std_logic:= 'X';             -- MISO
			MOSI       : out std_logic;                                       -- MOSI
			SCLK       : out std_logic;                                       -- SCLK
			SS_n       : out std_logic -- SS_n 
                                               
  );
end entity;

architecture rtl of system_top is

	component nios2_system is
        port (
            clk_clk                            : in  std_logic                    := 'X';             -- clk
            pio_irq_external_connection_export : in  std_logic_vector(2 downto 0) := (others => 'X'); -- export
            pio_led_external_connection_export : out std_logic_vector(9 downto 0);                    -- export
            pio_sw_external_connection_export  : in  std_logic_vector(9 downto 0) := (others => 'X'); -- export
            reset_reset_n                      : in  std_logic                    := 'X';             -- reset_n
            spi_external_connection_MISO                : in  std_logic                    := 'X';             -- MISO
            spi_external_connection_MOSI                : out std_logic;                                       -- MOSI
            spi_external_connection_SCLK                : out std_logic;                                       -- SCLK
            spi_external_connection_SS_n                : out std_logic;                                       -- SS_n
            uart_basic_external_connection_rx               : in  std_logic                    := 'X';             -- rx
            uart_basic_external_connection_tx               : out std_logic                                        -- tx
        );
    end component;
	 

  -- -- Two synchronization registers for the 3-input interrupts
  signal irq_sync_r1 : std_logic_vector(2 downto 0);
  signal irq_sync_r2 : std_logic_vector(2 downto 0);
  
  signal rx_sync_r1 : std_logic;
  signal rx_sync_r2 : std_logic; 
   
	signal SPI_MISO_sync_r1: std_logic;
  signal SPI_MISO_sync_r2: std_logic;
  
  
  
  

begin

  -- The irq input signal is a button press which is asynchronous to the system clock
  -- The irq input must therefore be synchronized
  
 
  
  
  
  
  p_sync: process(clk)   --process with new clock
  begin 
    if rising_edge(clk) then
      --irq_sync <= irq_sync(0) & irq; --synchronization shift register
		      irq_sync_r1 <= irq;
            irq_sync_r2 <= irq_sync_r1;
				
				
		      rx_sync_r1 <= rx;
            rx_sync_r2 <= rx_sync_r1;

            SPI_MISO_sync_r1 <= MISO ;
            SPI_MISO_sync_r2 <= SPI_MISO_sync_r1;
				
				
    end if;
  end process;

  u0 :  nios2_system
		port map  (
		
			clk_clk                            => clk,                         
			
			
			pio_irq_external_connection_export => irq,  --    pio_irq_external_connection.export
			
			pio_led_external_connection_export => led, --    pio_led_external_connection.export
			pio_sw_external_connection_export  => sw,  --     pio_sw_external_connection.export
			reset_reset_n                      => arst_n,     
			
			uart_basic_external_connection_tx  => tx,  -- uart_basic_external_connection.tx
			uart_basic_external_connection_rx  => rx_sync_r2,                                    --                               .rx
			
			spi_external_connection_MISO       => SPI_MISO_sync_r2,       --        spi_external_connection.MISO
			spi_external_connection_MOSI       => MOSI,       --                               .MOSI
			spi_external_connection_SCLK       => SCLK,       --                               .SCLK
			spi_external_connection_SS_n       => SS_n        --                               .SS_n
		);
  

  end architecture rtl;