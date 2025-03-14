
namespace eval hip_recfg_slave {
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    return $memory_files
  }
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    dict set design_files "hip_recfg_slave_st_dc_fifo_1951_tfgfkki.v"        "$QSYS_SIMDIR/../st_dc_fifo_1951/sim/hip_recfg_slave_st_dc_fifo_1951_tfgfkki.v"   
    dict set design_files "altera_reset_synchronizer.v"                      "$QSYS_SIMDIR/../st_dc_fifo_1951/sim/altera_reset_synchronizer.v"                 
    dict set design_files "altera_dcfifo_synchronizer_bundle.v"              "$QSYS_SIMDIR/../st_dc_fifo_1951/sim/altera_dcfifo_synchronizer_bundle.v"         
    dict set design_files "altera_std_synchronizer_nocut.v"                  "$QSYS_SIMDIR/../st_dc_fifo_1951/sim/altera_std_synchronizer_nocut.v"             
    dict set design_files "hip_recfg_slave_mm_ccb_st_dc_fifo_1921_waguglq.v" "$QSYS_SIMDIR/../mm_ccb_1921/sim/hip_recfg_slave_mm_ccb_st_dc_fifo_1921_waguglq.v"
    dict set design_files "hip_recfg_slave_mm_ccb_st_dc_fifo_1921_cp56ncq.v" "$QSYS_SIMDIR/../mm_ccb_1921/sim/hip_recfg_slave_mm_ccb_st_dc_fifo_1921_cp56ncq.v"
    dict set design_files "hip_recfg_slave_mm_ccb_1921_lcsq4ni.v"            "$QSYS_SIMDIR/../mm_ccb_1921/sim/hip_recfg_slave_mm_ccb_1921_lcsq4ni.v"           
    dict set design_files "hip_recfg_slave.v"                                "$QSYS_SIMDIR/hip_recfg_slave.v"                                                  
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
