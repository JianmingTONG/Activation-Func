
# set search_path [list ./rtl \
              
# set target_library [list tcbn28hpcplusbwp12t30p140ffg0p88v0c.db]

set work_dir analysis
analyze -work $work_dir -format verilog {./Activation-Func/ActivationFunctionLib.v}
set top_design hardtanh_sign
current_design hardtanh_sign






set clock_name "iClk"
set reset_name "iRst"
set clk_period 100.0
set clk_latency [expr $clk_period/10]
set input_delay [expr $clk_period/4] 
set output_delay [expr $clk_period/4]
set area_desired 0
# set wire_loskpyead_model "smic18_wl20"
# set output_load "typical/NAND2BX1/AN"

set root_directory            ./hardtanh/hardtanh32_2


set timing_report             $root_directory/report/timing.rpt
set timingmax20report         $root_directory/report/active_design_timing.rpt
set timing_max20_report       $root_directory/report/timing_max20.rpt
set area_report               $root_directory/report/area.rpt 
set references_report         $root_directory/report/design_references.rpt
​# set cell_report               $root_directory/report/cell.rpt
set constraint_report         $root_directory/report/constraint.rpt
set power_report              $root_directory/report/power.rpt
set check_syntax_report       $root_directory/report/syntax.rpt
set netlist_report            $root_directory/report/netlist.rpt

define_design_lib $work_dir -path $work_dir
elaborate $top_design -work $work_dir
current_design hardtanh_sign
 
link

if {[check_design] ==0} {
    echo "Check Design Error"
    exit 
}

set_wire_load_mode top

create_clock -name $clock_name -period [expr $clk_period] [get_ports $clock_name]

set_clock_uncertainty -setup 0.1 [get_clocks $clock_name]
set_clock_latency $clk_latency [get_clocks $clock_name]
set_dont_touch_network [get_clocks $clock_name]
set_dont_touch_network [get_ports $reset_name]
set_ideal_network [get_ports $reset_name]
# -----drive------
# set_driving_cell -lib_cell xr02d2 -pin A1 -library CSM35OS142_typ [all_inputs]
# set_driving_cell -lib_cell NAND2BX1 -pin Y [all_inputs]
set_drive 0 [get_ports $clock_name]
set_drive 0 [get_ports $reset_name]

set allin_except_CLK [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay [expr $input_delay] -clock $clock_name $allin_except_CLK
set_output_delay [expr $output_delay] -clock $clock_name [all_outputs]
# -----Output load------
#set_load [load_of $output_load] [all_outputs]
set auto_wire_load_selection true
# ----- Area ------
set_max_area $area_desired
# ----- insert buffer replace assign ------
set_fix_multiple_port_nets -all -buffer_constants

compile -map_effort medium -boundary_optimization

# remove_unconnected_ports [get_cells -hier {*}]
# change_names  -hierarchy -rules TAN_RULE
report_timing -delay max -max_paths 1 > $timing_report 
report_timing -delay max -path end -max_path 80 > $timing_max20_report
report_area > $area_report
report_reference > $references_report
# report_cell [get_cells -hier *] > $cell_report
report_constraint -all_violators -verbose > $constraint_report
report_power -analysis_effort high -verbose > $power_report
check_design > $check_syntax_report

# write_netlist > /
 
# change_names -rule verilog –hier
write -format verilog -hierarchy -output $netlist_report
# write -format db -hierarchy -output $out_db
# write_sdf $out_sdf 
# write_sdc $out_sdc 
exit

