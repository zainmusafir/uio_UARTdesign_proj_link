
module nios2_system (
	clk_clk,
	pio_irq_external_connection_export,
	pio_led_external_connection_export,
	pio_sw_external_connection_export,
	reset_reset_n,
	uart_basic_external_connection_tx,
	uart_basic_external_connection_rx,
	spi_external_connection_MISO,
	spi_external_connection_MOSI,
	spi_external_connection_SCLK,
	spi_external_connection_SS_n);	

	input		clk_clk;
	input	[2:0]	pio_irq_external_connection_export;
	output	[9:0]	pio_led_external_connection_export;
	input	[9:0]	pio_sw_external_connection_export;
	input		reset_reset_n;
	output		uart_basic_external_connection_tx;
	input		uart_basic_external_connection_rx;
	input		spi_external_connection_MISO;
	output		spi_external_connection_MOSI;
	output		spi_external_connection_SCLK;
	output		spi_external_connection_SS_n;
endmodule
