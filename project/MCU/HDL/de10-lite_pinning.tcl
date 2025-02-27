# de10-lite_pinning.tcl

# Dedicated FPGA clock pin for 50 MHz clock
set_location_assignment PIN_P11 -to clk

# key0 - used as reset
set_location_assignment PIN_B8 -to arst_n    


set_location_assignment PIN_C10 -to sw[0]
set_location_assignment PIN_C11 -to sw[1]
set_location_assignment PIN_D12 -to sw[2]
set_location_assignment PIN_C12 -to sw[3]
set_location_assignment PIN_A12 -to sw[4]
set_location_assignment PIN_B12 -to sw[5]
set_location_assignment PIN_A13 -to sw[6]
set_location_assignment PIN_A14 -to sw[7]
set_location_assignment PIN_B14 -to sw[8]
set_location_assignment PIN_F15 -to sw[9]

set_location_assignment PIN_A8 -to led[0]
set_location_assignment PIN_A9 -to led[1]
set_location_assignment PIN_A10 -to led[2]
set_location_assignment PIN_B10 -to led[3]
set_location_assignment PIN_D13 -to led[4]
set_location_assignment PIN_C13 -to led[5]
set_location_assignment PIN_E14 -to led[6]
set_location_assignment PIN_D14 -to led[7]
set_location_assignment PIN_A11 -to led[8]
set_location_assignment PIN_B11 -to led[9]


#To avoid that the FPGA is driving an unintended value on pins that are not in use:
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"


#accelerometer sensor
set_location_assignment PIN_V11 -to MOSI
set_location_assignment PIN_V12 -to MISO
set_location_assignment PIN_AB16 -to SS_n
set_location_assignment PIN_AB15 -to SCLK


set_location_assignment PIN_A7 -to irq[0]

set_location_assignment PIN_Y14 -to irq[1]
set_location_assignment PIN_Y13 -to irq[2]


#key1 -interrupt
# key1 - used as interrupt
#set_location_assignment PIN_A7 -to irq

#tx rx of ze board
set_location_assignment PIN_V10 -to tx
set_location_assignment PIN_W10 -to rx
