	nios2_system u0 (
		.clk_clk                            (<connected-to-clk_clk>),                            //                            clk.clk
		.pio_irq_external_connection_export (<connected-to-pio_irq_external_connection_export>), //    pio_irq_external_connection.export
		.pio_led_external_connection_export (<connected-to-pio_led_external_connection_export>), //    pio_led_external_connection.export
		.pio_sw_external_connection_export  (<connected-to-pio_sw_external_connection_export>),  //     pio_sw_external_connection.export
		.reset_reset_n                      (<connected-to-reset_reset_n>),                      //                          reset.reset_n
		.uart_basic_external_connection_tx  (<connected-to-uart_basic_external_connection_tx>),  // uart_basic_external_connection.tx
		.uart_basic_external_connection_rx  (<connected-to-uart_basic_external_connection_rx>),  //                               .rx
		.spi_external_connection_MISO       (<connected-to-spi_external_connection_MISO>),       //        spi_external_connection.MISO
		.spi_external_connection_MOSI       (<connected-to-spi_external_connection_MOSI>),       //                               .MOSI
		.spi_external_connection_SCLK       (<connected-to-spi_external_connection_SCLK>),       //                               .SCLK
		.spi_external_connection_SS_n       (<connected-to-spi_external_connection_SS_n>)        //                               .SS_n
	);

