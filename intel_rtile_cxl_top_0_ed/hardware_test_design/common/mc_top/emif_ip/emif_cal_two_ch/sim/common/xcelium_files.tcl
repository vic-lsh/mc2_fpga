
namespace eval emif_cal_two_ch {
  proc get_design_libraries {} {
    set libraries [dict create]
    dict set libraries altera_emif_cal_iossm_274 1
    dict set libraries altera_emif_cal_274       1
    dict set libraries emif_cal_two_ch           1
    return $libraries
  }
  
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    lappend memory_files "$QSYS_SIMDIR/../altera_emif_cal_iossm_274/sim/emif_cal_two_ch_altera_emif_cal_iossm_274_psjm22a_code.hex"
    lappend memory_files "$QSYS_SIMDIR/../altera_emif_cal_iossm_274/sim/emif_cal_two_ch_altera_emif_cal_iossm_274_psjm22a_sim_global_param_tbl.hex"
    lappend memory_files "$QSYS_SIMDIR/../altera_emif_cal_iossm_274/sim/emif_cal_two_ch_altera_emif_cal_iossm_274_psjm22a_synth_global_param_tbl.hex"
    return $memory_files
  }
  
  proc get_common_design_files {USER_DEFINED_COMPILE_OPTIONS USER_DEFINED_VERILOG_COMPILE_OPTIONS USER_DEFINED_VHDL_COMPILE_OPTIONS QSYS_SIMDIR} {
    set design_files [dict create]
    return $design_files
  }
  
  proc get_design_files {USER_DEFINED_COMPILE_OPTIONS USER_DEFINED_VERILOG_COMPILE_OPTIONS USER_DEFINED_VHDL_COMPILE_OPTIONS QSYS_SIMDIR} {
    set design_files [list]
    lappend design_files "xmvlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"$QSYS_SIMDIR/../altera_emif_cal_iossm_274/sim/altera_emif_cal_iossm.sv\"  -work altera_emif_cal_iossm_274 -cdslib  ./cds_libs/altera_emif_cal_iossm_274.cds.lib"                                 
    lappend design_files "xmvlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"$QSYS_SIMDIR/../altera_emif_cal_iossm_274/sim/altera_emif_f2c_gearbox.sv\"  -work altera_emif_cal_iossm_274 -cdslib  ./cds_libs/altera_emif_cal_iossm_274.cds.lib"                               
    lappend design_files "xmvlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"$QSYS_SIMDIR/../altera_emif_cal_iossm_274/sim/emif_cal_two_ch_altera_emif_cal_iossm_274_psjm22a_arch.sv\"  -work altera_emif_cal_iossm_274 -cdslib  ./cds_libs/altera_emif_cal_iossm_274.cds.lib"
    lappend design_files "xmvlog -sv $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"$QSYS_SIMDIR/../altera_emif_cal_iossm_274/sim/emif_cal_two_ch_altera_emif_cal_iossm_274_psjm22a.sv\"  -work altera_emif_cal_iossm_274 -cdslib  ./cds_libs/altera_emif_cal_iossm_274.cds.lib"     
    lappend design_files "xmvlog -compcnfg $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"$QSYS_SIMDIR/../altera_emif_cal_274/sim/emif_cal_two_ch_altera_emif_cal_274_w6umeni.v\"  -work altera_emif_cal_274"                                                                        
    lappend design_files "xmvlog -compcnfg $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"$QSYS_SIMDIR/emif_cal_two_ch.v\"  -work emif_cal_two_ch"                                                                                                                                   
    return $design_files
  }
  
  proc get_non_duplicate_elab_option {ELAB_OPTIONS NEW_ELAB_OPTION} {
    set IS_DUPLICATE [string first $NEW_ELAB_OPTION $ELAB_OPTIONS]
    if {$IS_DUPLICATE == -1} {
      return $NEW_ELAB_OPTION
    } else {
      return ""
    }
  }
  
  
  proc get_elab_options {SIMULATOR_TOOL_BITNESS} {
    set ELAB_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ELAB_OPTIONS
  }
  
  
  proc get_sim_options {SIMULATOR_TOOL_BITNESS} {
    set SIM_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $SIM_OPTIONS
  }
  
  
  proc get_env_variables {SIMULATOR_TOOL_BITNESS} {
    set ENV_VARIABLES [dict create]
    set LD_LIBRARY_PATH [dict create]
    dict set ENV_VARIABLES "LD_LIBRARY_PATH" $LD_LIBRARY_PATH
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ENV_VARIABLES
  }
  
  
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    
    return $libraries
  }
  
}
