
namespace eval ccl_csb2wire_csr {
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
    dict set design_files "ccl_csb2wire_csr_altera_avalon_mm_bridge_2010_xnk2xbi.v" "$QSYS_SIMDIR/../altera_avalon_mm_bridge_2010/sim/ccl_csb2wire_csr_altera_avalon_mm_bridge_2010_xnk2xbi.v"
    dict set design_files "altera_merlin_waitrequest_adapter.v"                     "$QSYS_SIMDIR/../altera_avalon_mm_bridge_2010/sim/altera_merlin_waitrequest_adapter.v"                    
    dict set design_files "altera_avalon_sc_fifo.v"                                 "$QSYS_SIMDIR/../altera_avalon_mm_bridge_2010/sim/altera_avalon_sc_fifo.v"                                
    dict set design_files "ccl_csb2wire_csr.v"                                      "$QSYS_SIMDIR/ccl_csb2wire_csr.v"                                                                         
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
