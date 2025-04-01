# Source the environment file that sets $libDir, $designDir, $outDir, etc.
source env.tcl

# Set the target and link libraries (update the path as needed)
set target_library "$libDir/fsd0a_90nm_generic_core/timing/fsd0a_a_generic_core_tt1v25c.db"
set link_library "* $target_library"

#----------------------------------------------------------------------------
# Analyze all VHDL files for the design
#----------------------------------------------------------------------------
# First, analyze the package and core files from the sha256core directory
analyze -format vhdl "$designDir/rtl/vhdl/sha256core/sha_256_pkg.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/sha256core/btc_dsha.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/sha256core/sha_256_comp_func_1c.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/sha256core/sha_256_chunk.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/sha256core/sha_256_ext_func.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/sha256core/sha_256_comp_func.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/sha256core/sha_256_ext_func_1c.vhd"

# Then, analyze the support modules from the misc directory
analyze -format vhdl "$designDir/rtl/vhdl/misc/HandShake.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/misc/SyncReset.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/misc/edgedtc.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/misc/pipelines_without_reset.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/misc/sdpram_infer_read_first.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/misc/sdpram_infer_read_first_outreg.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/misc/sdpram_infer_read_first_outreset.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/misc/sync_fifo_fwft_infer.vhd"
analyze -format vhdl "$designDir/rtl/vhdl/misc/sync_fifo_infer.vhd"

#----------------------------------------------------------------------------
# Elaborate the design
#----------------------------------------------------------------------------
# Assume the top-level entity is defined in btc_dsha.vhd as 'btc_dsha'
elaborate btc_dsha -library WORK

#----------------------------------------------------------------------------
# Set synthesis constraints
#----------------------------------------------------------------------------
# Specify the wire load model for timing optimizations
set_wire_load_model -name G50K

# Set the area constraint (adjust the value if necessary)
set_max_area 55000

# Create the design clock. Assuming the clock net in the design is named 'blif_clk_net'
create_clock blif_clk_net -period 0.6 -name blif_clk_net

# Set input and output delays relative to the clock
set_input_delay 0 -max -clock blif_clk_net [all_inputs]
set_output_delay 0 -max -clock blif_clk_net [all_outputs]

# Prevent the clock network from being optimized away
dont_touch_network blif_clk_net

#----------------------------------------------------------------------------
# Check design integrity
#----------------------------------------------------------------------------
check_design > $outDir/check_design.txt
check_timing > $outDir/check_timing.txt

#----------------------------------------------------------------------------
# Synthesis: Unique instance names and compile
#----------------------------------------------------------------------------
uniquify
compile -map_effort medium -ungroup_all

#----------------------------------------------------------------------------
# Rename instances and generate netlist for post-synthesis simulation
#----------------------------------------------------------------------------
change_names -rules verilog -hierarchy
write -format verilog -hierarchy -output $designDir/btc_dsha_netlist_synopsys.v
write_sdc $designDir/btc_dsha.sdc

#----------------------------------------------------------------------------
# Generate various reports
#----------------------------------------------------------------------------
report_area > $outDir/area_report.txt
report_timing > $outDir/timing_report.txt
report_power > $outDir/power_report.txt
report_constraint -all_violators > $outDir/violator_report.txt
report_register -level_sensitive > $outDir/latch_report.txt

exit