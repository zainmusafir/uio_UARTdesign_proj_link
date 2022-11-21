library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;

entity system_top is
  port (
         clk_clk                            : in  std_logic                    := 'X';             -- clk
			
			pio_irq_external_connection_export : in  std_logic_vector(2 downto 0) := (others => 'X'); -- export
			pio_led_external_connection_export : out std_logic_vector(9 downto 0);                    -- export
			pio_sw_external_connection_export  : in  std_logic_vector(9 downto 0) := (others => 'X'); -- export
			reset_reset_n                      : in  std_logic                    := 'X';             -- reset_n
			
			uart_basic_external_connection_tx  : out std_logic;                                       -- tx
			uart_basic_external_connection_rx  : in  std_logic                    := 'X';             -- rx
			
			spi_external_connection_MISO       : in  std_logic                    := 'X';             -- MISO
			spi_external_connection_MOSI       : out std_logic;                                       -- MOSI
			spi_external_connection_SCLK       : out std_logic;                                       -- SCLK
			spi_external_connection_SS_n       : out std_logic -- SS_n 
                                               
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
  
 
  
  
  
  
  p_sync: process(clk_clk)   --process with new clock
  begin 
    if rising_edge(clk_clk) then
      --irq_sync <= irq_sync(0) & irq; --synchronization shift register
		      irq_sync_r1 <= pio_irq_external_connection_export;
            irq_sync_r2 <= irq_sync_r1;
				
				
		      rx_sync_r1 <= uart_basic_external_connection_rx;
            rx_sync_r2 <= rx_sync_r1;

            SPI_MISO_sync_r1 <= spi_external_connection_MISO ;
            SPI_MISO_sync_r2 <= SPI_MISO_sync_r1;
				
				
    end if;
  end process;

  u0 :  nios2_system
		port map  (
		
			clk_clk                            => clk_clk,                            --                            clk.clk
			
			
			pio_irq_external_connection_export => irq_sync_r2,  --    pio_irq_external_connection.export
			
			pio_led_external_connection_export => pio_led_external_connection_export, --    pio_led_external_connection.export
			pio_sw_external_connection_export  => pio_sw_external_connection_export,  --     pio_sw_external_connection.export
			reset_reset_n                      => reset_reset_n,                      --                          reset.reset_n
			
			uart_basic_external_connection_tx  => uart_basic_external_connection_tx,  -- uart_basic_external_connection.tx
			uart_basic_external_connection_rx  => rx_sync_r2,                                    --                               .rx
			
			spi_external_connection_MISO       => SPI_MISO_sync_r2,       --        spi_external_connection.MISO
			spi_external_connection_MOSI       => spi_external_connection_MOSI,       --                               .MOSI
			spi_external_connection_SCLK       => spi_external_connection_SCLK,       --                               .SCLK
			spi_external_connection_SS_n       => spi_external_connection_SS_n        --                               .SS_n
		);
  

  end architecture rtl;