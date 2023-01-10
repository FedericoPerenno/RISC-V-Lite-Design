###################################################################

# Created by write_sdc on Tue Feb 15 20:12:57 2022

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
create_clock [get_ports Clk]  -name MY_CLK  -period 0  -waveform {0 0}
