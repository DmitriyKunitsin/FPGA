# User LED and Clock
set_property IOSTANDARD LVCMOS33 [get_ports led1]
set_property IOSTANDARD LVCMOS33 [get_ports led2]
set_property IOSTANDARD LVCMOS33 [get_ports led3]
set_property IOSTANDARD LVCMOS33 [get_ports led4]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports btn_reset]

set_property PACKAGE_PIN T12 [get_ports led1]
set_property PACKAGE_PIN U12 [get_ports led2]
set_property PACKAGE_PIN V12 [get_ports led3]
set_property PACKAGE_PIN W13 [get_ports led4]
set_property PACKAGE_PIN K17 [get_ports sys_clk]
set_property PACKAGE_PIN M20 [get_ports btn_reset]