
# (C) 2001-2025 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Intel 
# Program License Subscription Agreement, Intel MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Intel and sold by Intel 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 24.1 115 linux 2025.03.13.23:20:17

# ----------------------------------------
# vcsmx - auto-generated simulation script

# ----------------------------------------
# This script provides commands to simulate the following IP detected in
# your Quartus project:
#     emif_cal_two_ch
# 
# Intel recommends that you source this Quartus-generated IP simulation
# script from your own customized top-level script, and avoid editing this
# generated script.
# 
# To write a top-level shell script that compiles Intel simulation libraries 
# and the Quartus-generated IP in your project, along with your design and
# testbench files, copy the text from the TOP-LEVEL TEMPLATE section below
# into a new file, e.g. named "vcsmx_sim.sh", and modify text as directed.
# 
# You can also modify the simulation flow to suit your needs. Set the
# following variables to 1 to disable their corresponding processes:
# - SKIP_FILE_COPY: skip copying ROM/RAM initialization files
# - SKIP_DEV_COM: skip compiling the Quartus EDA simulation library
# - SKIP_COM: skip compiling Quartus-generated IP simulation files
# - SKIP_ELAB and SKIP_SIM: skip elaboration and simulation
# 
# ----------------------------------------
# # TOP-LEVEL TEMPLATE - BEGIN
# #
# # QSYS_SIMDIR is used in the Quartus-generated IP simulation script to
# # construct paths to the files required to simulate the IP in your Quartus
# # project. By default, the IP script assumes that you are launching the
# # simulator from the IP script location. If launching from another
# # location, set QSYS_SIMDIR to the output directory you specified when you
# # generated the IP script, relative to the directory from which you launch
# # the simulator. In this case, you must also copy the generated library
# # setup "synopsys_sim.setup" into the location from which you launch the
# # simulator, or incorporate into any existing library setup.
# #
# # Run Quartus-generated IP simulation script once to compile Quartus EDA
# # simulation libraries and Quartus-generated IP simulation files, and copy
# # any ROM/RAM initialization files to the simulation directory.
# #
# # - If necessary, specify any compilation options:
# #   USER_DEFINED_COMPILE_OPTIONS
# #   USER_DEFINED_VHDL_COMPILE_OPTIONS applied to vhdl compiler
# #   USER_DEFINED_VERILOG_COMPILE_OPTIONS applied to verilog compiler
# #
# source <script generation output directory>/synopsys/vcsmx/vcsmx_setup.sh \
# SKIP_ELAB=1 \
# SKIP_SIM=1 \
# USER_DEFINED_COMPILE_OPTIONS=<compilation options for your design> \
# USER_DEFINED_VHDL_COMPILE_OPTIONS=<VHDL compilation options for your design> \
# USER_DEFINED_VERILOG_COMPILE_OPTIONS=<Verilog compilation options for your design> \
# QSYS_SIMDIR=<script generation output directory>
# #
# # Compile all design files and testbench files, including the top level.
# # (These are all the files required for simulation other than the files
# # compiled by the IP script)
# #
# vlogan <compilation options> <design and testbench files>
# #
# # TOP_LEVEL_NAME is used in this script to set the top-level simulation or
# # testbench module/entity name.
# #
# # Run the IP script again to elaborate and simulate the top level:
# # - Specify TOP_LEVEL_NAME and USER_DEFINED_ELAB_OPTIONS.
# # - Override the default USER_DEFINED_SIM_OPTIONS. For example, to run
# #   until $finish(), set to an empty string: USER_DEFINED_SIM_OPTIONS="".
# #
# source <script generation output directory>/synopsys/vcsmx/vcsmx_setup.sh \
# SKIP_FILE_COPY=1 \
# SKIP_DEV_COM=1 \
# SKIP_COM=1 \
# TOP_LEVEL_NAME="'-top <simulation top>'" \
# QSYS_SIMDIR=<script generation output directory> \
# USER_DEFINED_ELAB_OPTIONS=<elaboration options for your design> \
# USER_DEFINED_SIM_OPTIONS=<simulation options for your design>
# #
# # TOP-LEVEL TEMPLATE - END
# ----------------------------------------
# 
# IP SIMULATION SCRIPT
# ----------------------------------------
# If emif_cal_two_ch is one of several IP cores in your
# Quartus project, you can generate a simulation script
# suitable for inclusion in your top-level simulation
# script by running the following command line:
# 
# ip-setup-simulation --quartus-project=<quartus project>
# 
# ip-setup-simulation will discover the Intel IP
# within the Quartus project, and generate a unified
# script which supports all the Intel IP within the design.
# ----------------------------------------
# ACDS 24.1 115 linux 2025.03.13.23:20:17
# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="emif_cal_two_ch.emif_cal_two_ch"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="/mnt/sda1/intelFPGA_pro/24.1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="+vcs+finish+100"

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

#-------------------------------------------
# check tclsh version no earlier than 8.5 
version=$(echo "puts [package vcompare [info tclversion] 8.5]; exit" | tclsh)
if [ $version -eq -1 ]; then 
  echo "Error: Minimum required tcl package version is 8.5." >&2 
  exit 1 
fi 

# ----------------------------------------
# initialize simulation properties - DO NOT MODIFY!
ELAB_OPTIONS=""
SIM_OPTIONS=""
if [[ `vcs -platform` != *"amd64"* && `vcs -platform` != *"suse64"* && `vcs -platform` != *"linux64"* ]]; then
  SIMULATOR_TOOL_BITNESS="bit_32"
else
  SIMULATOR_TOOL_BITNESS="bit_64"
fi
TCLSCRIPT='
set QSYS_SIMDIR [lindex $argv 1]
set SIMULATOR_TOOL_BITNESS [lindex $argv 2]
source $QSYS_SIMDIR/common/vcsmx_files.tcl
set LD_LIBRARY_PATH [dict create]
set LD_LIBRARY_PATH [dict merge $LD_LIBRARY_PATH [dict get [emif_cal_two_ch::get_env_variables $SIMULATOR_TOOL_BITNESS] "LD_LIBRARY_PATH"]]
if {[dict size $LD_LIBRARY_PATH] !=0 } {
  set LD_LIBRARY_PATH [join [dict keys $LD_LIBRARY_PATH] ":"]
  puts "LD_LIBRARY_PATH=\"$LD_LIBRARY_PATH\""
}

set ELAB_OPTIONS ""
append ELAB_OPTIONS [emif_cal_two_ch::get_elab_options $SIMULATOR_TOOL_BITNESS]
puts "ELAB_OPTIONS+=\"$ELAB_OPTIONS\""
set SIM_OPTIONS ""
append SIM_OPTIONS [emif_cal_two_ch::get_sim_options $SIMULATOR_TOOL_BITNESS]
puts "SIM_OPTIONS+=\"$SIM_OPTIONS\""
exit 0
'
cmd_output=$(
tclsh -args "$QSYS_SIMDIR" "$SIMULATOR_TOOL_BITNESS" << SCRIPT
  $TCLSCRIPT
SCRIPT
)

eval $cmd_output

TCLSCRIPT='
set QSYS_SIMDIR [lindex $argv 1]
set libraries [dict create]
source $QSYS_SIMDIR/common/vcsmx_files.tcl
set libraries [dict merge $libraries [emif_cal_two_ch::get_design_libraries]]
set design_libraries [dict keys $libraries]
foreach file $design_libraries { puts "$file" }
exit 0
'
cmd_output=$(
tclsh -args "$QSYS_SIMDIR" << SCRIPT
  $TCLSCRIPT
SCRIPT
)

design_libraries=$cmd_output

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/lpm_ver/
mkdir -p ./libraries/sgate_ver/
mkdir -p ./libraries/altera_ver/
mkdir -p ./libraries/altera_mf_ver/
mkdir -p ./libraries/altera_lnsim_ver/
mkdir -p ./libraries/tennm_ver/
mkdir -p ./libraries/tennm_hssi_ver/
mkdir -p ./libraries/tennm_hssi_f1_ver/
mkdir -p ./libraries/tennm_hssi_r1_ver/
for library in $design_libraries
do
  mkdir -p ./libraries/$library
done

# ----------------------------------------
# copy RAM/ROM files to simulation directory
TCLSCRIPT='
set QSYS_SIMDIR [lindex $argv 1]
set memory_files [list]
source $QSYS_SIMDIR/common/vcsmx_files.tcl
set memory_files [concat $memory_files [emif_cal_two_ch::get_memory_files "$QSYS_SIMDIR"]]
foreach file $memory_files { puts "$file" }
exit 0
'
cmd_output=$(
tclsh -args "$QSYS_SIMDIR" << SCRIPT
  $TCLSCRIPT
SCRIPT
)

memory_files=$cmd_output
if [ $SKIP_FILE_COPY -eq 0 ]; then
  for file in $memory_files
  do
    cp -f $file ./
  done
fi

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  vlogan +v2k $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                            "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                          -work lpm_ver          
  vlogan +v2k $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                            "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                             -work sgate_ver        
  vlogan +v2k $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                            "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                 -work altera_ver       
  vlogan +v2k $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                            "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                         -work altera_mf_ver    
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                     -work altera_lnsim_ver 
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/tennm_atoms.sv"                      -work tennm_ver        
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/tennm_atoms_ncrypt.sv"      -work tennm_ver        
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/fmica_atoms_ncrypt.sv"               -work tennm_ver        
                                                                                                                                                                                                                           
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/tennm_hssi_atoms.sv"                 -work tennm_hssi_ver   
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/tennm_hssi_atoms_ncrypt.sv"          -work tennm_hssi_ver   
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/ctfb_hssi_atoms.sv"                  -work tennm_hssi_f1_ver
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/ctfb_hssi_atoms_ncrypt.sv"  -work tennm_hssi_f1_ver
  vlogan +v2k -sverilog +define+QUARTUS_ENABLE_DPI_FORCE $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/ctfb_hssi_atoms2_ncrypt.sv" -work tennm_hssi_f1_ver
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/ctr_hssi_atoms.sv"                   -work tennm_hssi_r1_ver
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/ctr_hssi_atoms_ncrypt.sv"            -work tennm_hssi_r1_ver
  vlogan +v2k -sverilog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS                                  "$QUARTUS_INSTALL_DIR/eda/sim_lib/ctrb_hssi_atoms_ncrypt.sv"           -work tennm_hssi_r1_ver
fi

# ----------------------------------------
# add device library elaboration and simulation properties
ELAB_OPTIONS="$ELAB_OPTIONS $QUARTUS_INSTALL_DIR/eda/sim_lib/simsf_dpi.cpp"
SIM_OPTIONS="$SIM_OPTIONS -sv_lib $QUARTUS_INSTALL_DIR/eda/sim_lib/libdb_gdr_fec"

# ----------------------------------------
# get common system verilog package design files
TCLSCRIPT='
set USER_DEFINED_COMPILE_OPTIONS [lindex $argv 1]
set USER_DEFINED_VERILOG_COMPILE_OPTIONS [lindex $argv 2]
set USER_DEFINED_VHDL_COMPILE_OPTIONS [lindex $argv 3]
set QSYS_SIMDIR [lindex $argv 4]
set design_files [dict create]
source $QSYS_SIMDIR/common/vcsmx_files.tcl
set design_files [dict merge $design_files [emif_cal_two_ch::get_common_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR"]]
set common_design_files [dict values $design_files]
foreach file $common_design_files { puts "$file" }
exit 0
'
cmd_output=$(
tclsh -args "$USER_DEFINED_COMPILE_OPTIONS" "$USER_DEFINED_VERILOG_COMPILE_OPTIONS" "$USER_DEFINED_VHDL_COMPILE_OPTIONS" "$QSYS_SIMDIR" << SCRIPT
  $TCLSCRIPT
SCRIPT
)

common_design_files=$cmd_output

# ----------------------------------------
# get design files
TCLSCRIPT='
set USER_DEFINED_COMPILE_OPTIONS [lindex $argv 1]
set USER_DEFINED_VERILOG_COMPILE_OPTIONS [lindex $argv 2]
set USER_DEFINED_VHDL_COMPILE_OPTIONS [lindex $argv 3]
set QSYS_SIMDIR [lindex $argv 4]
set files [list]
source $QSYS_SIMDIR/common/vcsmx_files.tcl
set files [concat $files [emif_cal_two_ch::get_design_files $USER_DEFINED_COMPILE_OPTIONS $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_VHDL_COMPILE_OPTIONS "$QSYS_SIMDIR"]]
set design_files $files
foreach file $design_files { puts "$file" }
exit 0
'
cmd_output=$(
tclsh -args "$USER_DEFINED_COMPILE_OPTIONS" "$USER_DEFINED_VERILOG_COMPILE_OPTIONS" "$USER_DEFINED_VHDL_COMPILE_OPTIONS" "$QSYS_SIMDIR" << SCRIPT
  $TCLSCRIPT
SCRIPT
)

design_files=$cmd_output

# ----------------------------------------
# get DPI libraries
TCLSCRIPT='
set QSYS_SIMDIR [lindex $argv 1]
set libraries [dict create]
source $QSYS_SIMDIR/common/vcsmx_files.tcl
set libraries [dict merge $libraries [emif_cal_two_ch::get_dpi_libraries "$QSYS_SIMDIR"]]
set dpi_libraries [dict values $libraries]
foreach library $dpi_libraries { puts -nonewline "$library " }
exit 0
'
cmd_output=$(
tclsh -args "$QSYS_SIMDIR" << SCRIPT
  $TCLSCRIPT
SCRIPT
)

dpi_libraries=$cmd_output

if [ -n "$dpi_libraries" ]; then
  echo "Using DPI Library settings"
  LDFLAGS_LOCAL=""
  for library in $dpi_libraries; do
    library=$(readlink -m $library)
    FILENAME=${library##*/}
    LDFLAGS_LOCAL+=" -Wl,-rpath ${library%/*} -L ${library%/*} -l${FILENAME:3}"
  done
  export LDFLAGS="$LDFLAGS_LOCAL $LDFLAGS"
  ELAB_OPTIONS="$ELAB_OPTIONS -debug_access+r+w+nomemcbk"
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  eval "$common_design_files"
  eval "$design_files"
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  vcs -lca -t ps -liblist_work $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS
fi
