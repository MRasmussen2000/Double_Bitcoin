# Source the environment file to set paths such as $designDir and $outDir.
source env.tcl

# Set the basename for configuration files to match your design.
set basename btc_dsha

# Load the design configuration file.
if { [file exists "$designDir/$basename.conf"] } {
    loadConfig "$designDir/$basename.conf" 1
} else {
    puts "Warning: $designDir/$basename.conf not found. Continuing without it."
}

# Source the global settings file.
if { [file exists "$designDir/$basename.global"] } {
    source "$designDir/$basename.global"
} else {
    puts "Warning: $designDir/$basename.global not found. Continuing without it."
}

# Initialize the design.
init_design

# Read the synthesized netlist.
if { [file exists "$designDir/$init_verilog"] } {
    read_netlist "$designDir/$init_verilog" -format verilog
} else {
    puts "Error: Netlist file $designDir/$init_verilog not found."
    exit 1
}

# Set the top-level cell.
set_top $init_top_cell

# Optionally, if you have a floorplan specification, load it here:
# loadFPlan "$designDir/$basename.fp"

# Perform pre-placement timing analysis.
timeDesign -preplace -outDir preplaceTimingReports

# Set placement options.
# Uncomment one of the following based on your design flow:
# setPlaceMode -cutSequence VVVHHH -timingdriven true
# setPlaceMode -cutSequence HHHVVV -timingdriven true

# Disable use of floorplan hints during placement.
set delaycal_use_default_delay_limit 1000
setPlaceMode -place_design_floorplan_mode false

# Place the standard cells.
placeDesign

# Verify the placement.
checkPlace

# Save the placed design in encrypted format.
saveDesign $outDir/$basename.placed.enc

# Export a DEF file containing placement, routing, floorplan, and netlist information.
defOut -placement -routing -floorplan -netlist $outDir/placed.def

# Launch the GUI to view the final design.
win

# Report bounding box net length.
reportNetLen

# Perform pre-CTS timing analysis and save the reports.
timeDesign -preCTS -outDir prectsTimingReports

exit