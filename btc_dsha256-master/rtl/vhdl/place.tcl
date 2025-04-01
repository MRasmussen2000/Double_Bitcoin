# Source the environment file to set paths such as $designDir and $outDir
source env.tcl

# Set the basename for configuration and floorplan files to match your design.
set basename btc_dsha

# Load/import design, constraints, and libraries.
# Ensure that btc_dsha.global exists and has the proper settings for your design.
source $designDir/$basename.global
init_design

# If you have a floorplan file, load it here. Otherwise, let Innovus determine the die size.
# Uncomment the following if you have a floorplan specification:
# loadFPlan "$designDir/$basename.fp"

# Perform timing analysis before placement.
timeDesign -preplace -outDir preplaceTimingReports

# Set placement options.
# Uncomment one of the following setPlaceMode commands based on your flow requirements:
# Part 2: For one type of placement cut sequence
# setPlaceMode -cutSequence VVVHHH -timingdriven true
# Part 3: For an alternative placement cut sequence
# setPlaceMode -cutSequence HHHVVV -timingdriven true

# Set default delay limit and disable using floorplan hints during placement.
set delaycal_use_default_delay_limit 1000
setPlaceMode -place_design_floorplan_mode false

# Run placement of the standard cells.
placeDesign

# Verify the placement.
checkPlace

# Save the placed design in encrypted format.
saveDesign $outDir/$basename.placed.enc

# Export a DEF file containing placement, routing, floorplan, and netlist information.
defOut -placement -routing -floorplan -netlist $outDir/placed.def

# Launch the GUI to view the final design.
win

# Report bounding box net length for further analysis.
reportNetLen

# Perform timing analysis pre-CTS and save the reports.
timeDesign -preCTS -outDir prectsTimingReports

exit