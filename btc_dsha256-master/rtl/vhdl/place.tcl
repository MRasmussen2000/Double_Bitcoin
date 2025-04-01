# Source the environment file to set paths such as $designDir and $outDir
source env.tcl

# Set the basename for configuration and floorplan files to match your design.
set basename btc_dsha

# Load configuration file if it exists.
if { [file exists "$designDir/$basename.conf"] } {
    loadConfig "$designDir/$basename.conf" 1
} else {
    puts "Warning: $designDir/$basename.conf not found. Continuing without it."
}

# Source the global settings file if it exists.
if { [file exists "$designDir/$basename.global"] } {
    source "$designDir/$basename.global"
} else {
    puts "Warning: $designDir/$basename.global not found. Continuing without it."
}

# Initialize the design.
init_design

# If you have a floorplan specification file, load it here.
# For example, if you have a floorplan file named btc_dsha.fp, uncomment the following line:
# loadFPlan "$designDir/$basename.fp"

# Timing analysis before placement.
timeDesign -preplace -outDir preplaceTimingReports

# Set placement options.
# Uncomment one of the following lines as needed for your flow:
# setPlaceMode -cutSequence VVVHHH -timingdriven true
# setPlaceMode -cutSequence HHHVVV -timingdriven true

# Disable floorplan hints during placement.
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

# Perform timing analysis pre-CTS and save the reports.
timeDesign -preCTS -outDir prectsTimingReports

exit