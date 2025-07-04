
namespace eval bbs_slave {
  proc get_design_libraries {} {
    set libraries [dict create]
    dict set libraries altera_avalon_mm_bridge_2010 1
    dict set libraries bbs_slave                    1
    return $libraries
  }
  
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    return $memory_files
  }
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR} {
    set design_files [list]
    lappend design_files "-makelib altera_avalon_mm_bridge_2010 \"[normalize_path "$QSYS_SIMDIR/../altera_avalon_mm_bridge_2010/sim/bbs_slave_altera_avalon_mm_bridge_2010_xnk2xbi.v"]\"   -end"
    lappend design_files "-makelib altera_avalon_mm_bridge_2010 \"[normalize_path "$QSYS_SIMDIR/../altera_avalon_mm_bridge_2010/sim/altera_merlin_waitrequest_adapter.v"]\"   -end"             
    lappend design_files "-makelib altera_avalon_mm_bridge_2010 \"[normalize_path "$QSYS_SIMDIR/../altera_avalon_mm_bridge_2010/sim/altera_avalon_sc_fifo.v"]\"   -end"                         
    lappend design_files "-makelib bbs_slave \"[normalize_path "$QSYS_SIMDIR/bbs_slave.v"]\"   -end"                                                                                            
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
  
  
  proc normalize_path {FILEPATH} {
      if {[catch { package require fileutil } err]} { 
          return $FILEPATH 
      } 
      set path [fileutil::lexnormalize [file join [pwd] $FILEPATH]]  
      if {[file pathtype $FILEPATH] eq "relative"} { 
          set path [fileutil::relative [pwd] $path] 
      } 
      return $path 
  } 
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    
    return $libraries
  }
  
}
