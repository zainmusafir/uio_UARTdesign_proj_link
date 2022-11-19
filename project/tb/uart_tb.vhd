library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- UVVM Utility Library
-------------------------------------------------------------------------------
library uvvm_util;
context uvvm_util.uvvm_util_context;
-- The context statement is a way to group together packages that you would
-- like to include in your test bench.
-- The uvvm context can be found here:
-- https://github.com/UVVM/UVVM_Light/blob/master/src_util/uvvm_util_context.vhd
-- Have a look at the following description on how to use context
-- https://www.doulos.com/knowhow/vhdl/vhdl-2008-incorporates-existing-standards/#context
-------------------------------------------------------------------------------

entity uart_tb is
end uart_tb;


architecture tb of uart_tb is
begin

  -- Main test sequencer
  p_main_test_sequencer : process
    constant C_SCOPE : string := "TB seq.";
  begin
    ----------------------------------------------------------------------------------
    -- Set and report init conditions
    ----------------------------------------------------------------------------------
    report_global_ctrl(VOID);
    report_msg_id_panel(VOID);
    enable_log_msg(ALL_MESSAGES);
   
    ------------------------
    -- Begin simulation
    ------------------------
    log(ID_LOG_HDR, "Start Simulation of TB for UART controller", C_SCOPE);


    ------------------------
    -- End simulation
    ------------------------
    report_alert_counters(FINAL);  -- Report final counters and print conclusion for simulation (Success/Fail)
    log(ID_LOG_HDR, "SIMULATION COMPLETED", C_SCOPE);
    wait;
  end process;
end architecture;