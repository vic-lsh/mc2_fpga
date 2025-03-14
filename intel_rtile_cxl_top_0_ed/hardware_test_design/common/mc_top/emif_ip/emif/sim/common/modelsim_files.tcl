
namespace eval emif {
  proc get_design_libraries {} {
    set libraries [dict create]
    dict set libraries altera_emif_arch_fm_191 1
    dict set libraries altera_emif_fm_274      1
    dict set libraries emif                    1
    return $libraries
  }
  
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    lappend memory_files "[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/emif_altera_emif_arch_fm_191_ws7gkca_seq_params_synth.hex"]"
    return $memory_files
  }
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR} {
    set design_files [list]
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/emif_altera_emif_arch_fm_191_ws7gkca_top.sv"]\"   -end"
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_bufs.sv"]\"   -end"                
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_ufis.sv"]\"   -end"                
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_ufi_wrapper.sv"]\"   -end"         
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_buf_udir_se_i.sv"]\"   -end"       
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_buf_udir_se_o.sv"]\"   -end"       
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_buf_udir_df_i.sv"]\"   -end"       
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_buf_udir_df_o.sv"]\"   -end"       
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_buf_udir_cp_i.sv"]\"   -end"       
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_buf_bdir_df.sv"]\"   -end"         
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_buf_bdir_se.sv"]\"   -end"         
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_buf_unused.sv"]\"   -end"          
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_cal_counter.sv"]\"   -end"         
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_pll.sv"]\"   -end"                 
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_pll_fast_sim.sv"]\"   -end"        
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_pll_extra_clks.sv"]\"   -end"      
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_oct.sv"]\"   -end"                 
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_core_clks_rsts.sv"]\"   -end"      
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_hps_clks_rsts.sv"]\"   -end"       
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_local_reset.sv"]\"   -end"         
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_io_tiles_wrap.sv"]\"   -end"       
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_io_tiles.sv"]\"   -end"            
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_io_lane_remap.sv"]\"   -end"       
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_hmc_avl_if.sv"]\"   -end"          
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_hmc_sideband_if.sv"]\"   -end"     
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_hmc_mmr_if.sv"]\"   -end"          
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_hmc_amm_data_if.sv"]\"   -end"     
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_phylite_if.sv"]\"   -end"          
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_hmc_ast_data_if.sv"]\"   -end"     
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_afi_if.sv"]\"   -end"              
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_seq_if.sv"]\"   -end"              
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_emif_arch_fm_regs.sv"]\"   -end"                
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/altera_std_synchronizer_nocut.v"]\"   -end"            
    lappend design_files "-makelib altera_emif_arch_fm_191 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_arch_fm_191/sim/emif_altera_emif_arch_fm_191_ws7gkca.sv"]\"   -end"    
    lappend design_files "-makelib altera_emif_fm_274 \"[normalize_path "$QSYS_SIMDIR/../altera_emif_fm_274/sim/emif_altera_emif_fm_274_mqs4zra.v"]\"   -end"                    
    lappend design_files "-makelib emif \"[normalize_path "$QSYS_SIMDIR/emif.v"]\"   -end"                                                                                       
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
