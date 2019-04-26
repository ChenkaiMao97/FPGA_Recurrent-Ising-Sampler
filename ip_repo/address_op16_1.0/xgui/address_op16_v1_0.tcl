# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set C_S00_AXI_DATA_WIDTH [ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_S00_AXI_DATA_WIDTH}
  set C_S00_AXI_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of S_AXI address bus} ${C_S00_AXI_ADDR_WIDTH}
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDR_BIT { PARAM_VALUE.ADDR_BIT } {
	# Procedure called to update ADDR_BIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_BIT { PARAM_VALUE.ADDR_BIT } {
	# Procedure called to validate ADDR_BIT
	return true
}

proc update_PARAM_VALUE.HOLDER_COUNTER_BIT { PARAM_VALUE.HOLDER_COUNTER_BIT } {
	# Procedure called to update HOLDER_COUNTER_BIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HOLDER_COUNTER_BIT { PARAM_VALUE.HOLDER_COUNTER_BIT } {
	# Procedure called to validate HOLDER_COUNTER_BIT
	return true
}

proc update_PARAM_VALUE.MAX_HOLDER_COUNTER { PARAM_VALUE.MAX_HOLDER_COUNTER } {
	# Procedure called to update MAX_HOLDER_COUNTER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_HOLDER_COUNTER { PARAM_VALUE.MAX_HOLDER_COUNTER } {
	# Procedure called to validate MAX_HOLDER_COUNTER
	return true
}

proc update_PARAM_VALUE.URAM_LEN { PARAM_VALUE.URAM_LEN } {
	# Procedure called to update URAM_LEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.URAM_LEN { PARAM_VALUE.URAM_LEN } {
	# Procedure called to validate URAM_LEN
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.URAM_LEN { MODELPARAM_VALUE.URAM_LEN PARAM_VALUE.URAM_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.URAM_LEN}] ${MODELPARAM_VALUE.URAM_LEN}
}

proc update_MODELPARAM_VALUE.MAX_HOLDER_COUNTER { MODELPARAM_VALUE.MAX_HOLDER_COUNTER PARAM_VALUE.MAX_HOLDER_COUNTER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_HOLDER_COUNTER}] ${MODELPARAM_VALUE.MAX_HOLDER_COUNTER}
}

proc update_MODELPARAM_VALUE.HOLDER_COUNTER_BIT { MODELPARAM_VALUE.HOLDER_COUNTER_BIT PARAM_VALUE.HOLDER_COUNTER_BIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HOLDER_COUNTER_BIT}] ${MODELPARAM_VALUE.HOLDER_COUNTER_BIT}
}

proc update_MODELPARAM_VALUE.ADDR_BIT { MODELPARAM_VALUE.ADDR_BIT PARAM_VALUE.ADDR_BIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_BIT}] ${MODELPARAM_VALUE.ADDR_BIT}
}

