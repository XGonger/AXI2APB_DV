# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Sun Mar 30 23:34:32 2025
# Designs open: 1
#   Sim: /home/ICer/ic_prjs/AXI2APB/sim/out/obj/gon_axi2apb_tb.simv
# Toplevel windows open: 1
# 	TopLevel.2
#   Wave.1: 60 signals
#   Group count = 8
#   Group Group1 signal count = 15
#   Group Group2 signal count = 6
#   Group Group3 signal count = 5
#   Group Group4 signal count = 15
#   Group Group5 signal count = 7
#   Group Group6 signal count = 12
#   Group Group7 signal count = 2
#   Group Group8 signal count = 2
# End_DVE_Session_Save_Info

# DVE version: O-2018.09-1_Full64
# DVE build date: Oct 12 2018 21:19:11


#<Session mode="Full" path="/home/ICer/ic_prjs/AXI2APB/sim/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Liberation Sans Narrow,14,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state maximized -rect {{0 176} {2557 1272}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}
gui_set_toolbar_attributes -toolbar {S&pecman} -dock_state top
gui_set_toolbar_attributes -toolbar {S&pecman} -offset 0
gui_show_toolbar -toolbar {S&pecman}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.2}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 743} {child_wave_right 1809} {child_wave_colname 372} {child_wave_colvalue 367} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) none
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) none
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.2}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { [llength [lindex [gui_get_db -design Sim] 0]] == 0 } {
gui_set_env SIMSETUP::SIMARGS {{-ucligui -l run.log +ntb_random_seed=1 +UVM_TESTNAME=gon_axi2apb_smoke_test +UVM_VERBOSITY=UVM_HIGH -cm_dir out/cov.vdb -cm_name gon_axi2apb_smoke_test_1}}
gui_set_env SIMSETUP::SIMEXE {/home/ICer/ic_prjs/AXI2APB/sim/out/obj/gon_axi2apb_tb.simv}
gui_set_env SIMSETUP::ALLOW_POLL {0}
if { ![gui_is_db_opened -db {/home/ICer/ic_prjs/AXI2APB/sim/out/obj/gon_axi2apb_tb.simv}] } {
gui_sim_run Ucli -exe gon_axi2apb_tb.simv -args {-ucligui -l run.log +ntb_random_seed=1 +UVM_TESTNAME=gon_axi2apb_smoke_test +UVM_VERBOSITY=UVM_HIGH -cm_dir out/cov.vdb -cm_name gon_axi2apb_smoke_test_1} -dir /home/ICer/ic_prjs/AXI2APB/sim/out/obj -nosource
}
}
if { ![gui_sim_state -check active] } {error "Simulator did not start correctly" error}
gui_set_precision 10ps
gui_set_time_units 10ps
#</Database>

# DVE Global setting session: 


# Global: Breakpoints

# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {gon_axi2apb_tb.dut}


set _session_group_1 Group1
gui_sg_create "$_session_group_1"
set Group1 "$_session_group_1"

gui_sg_addsignal -group "$_session_group_1" { gon_axi2apb_tb.dut.aclk gon_axi2apb_tb.dut.aresetn gon_axi2apb_tb.dut.awid gon_axi2apb_tb.dut.awaddr gon_axi2apb_tb.dut.awlen {gon_axi2apb_tb.axi_if[0].debug_wr_length} gon_axi2apb_tb.dut.awsize {gon_axi2apb_tb.axi_if[0].debug_wr_size} gon_axi2apb_tb.dut.awburst {gon_axi2apb_tb.axi_if[0].debug_wr_type} gon_axi2apb_tb.dut.awcache gon_axi2apb_tb.dut.awprot gon_axi2apb_tb.dut.awlock gon_axi2apb_tb.dut.awvalid gon_axi2apb_tb.dut.awready }

set _session_group_2 Group2
gui_sg_create "$_session_group_2"
set Group2 "$_session_group_2"

gui_sg_addsignal -group "$_session_group_2" { gon_axi2apb_tb.dut.wid gon_axi2apb_tb.dut.wdata gon_axi2apb_tb.dut.wstrb gon_axi2apb_tb.dut.wlast gon_axi2apb_tb.dut.wvalid gon_axi2apb_tb.dut.wready }

set _session_group_3 Group3
gui_sg_create "$_session_group_3"
set Group3 "$_session_group_3"

gui_sg_addsignal -group "$_session_group_3" { gon_axi2apb_tb.dut.bid gon_axi2apb_tb.dut.bresp {gon_axi2apb_tb.axi_if[0].debug_wr_resp} gon_axi2apb_tb.dut.bvalid gon_axi2apb_tb.dut.bready }

set _session_group_4 Group4
gui_sg_create "$_session_group_4"
set Group4 "$_session_group_4"

gui_sg_addsignal -group "$_session_group_4" { gon_axi2apb_tb.dut.aclk gon_axi2apb_tb.dut.aresetn gon_axi2apb_tb.dut.arid gon_axi2apb_tb.dut.araddr gon_axi2apb_tb.dut.arlen {gon_axi2apb_tb.axi_if[0].debug_rd_length} gon_axi2apb_tb.dut.arsize {gon_axi2apb_tb.axi_if[0].debug_rd_size} gon_axi2apb_tb.dut.arburst {gon_axi2apb_tb.axi_if[0].debug_rd_type} gon_axi2apb_tb.dut.arcache gon_axi2apb_tb.dut.arprot gon_axi2apb_tb.dut.arlock gon_axi2apb_tb.dut.arvalid gon_axi2apb_tb.dut.arready }

set _session_group_5 Group5
gui_sg_create "$_session_group_5"
set Group5 "$_session_group_5"

gui_sg_addsignal -group "$_session_group_5" { gon_axi2apb_tb.dut.rid gon_axi2apb_tb.dut.rdata gon_axi2apb_tb.dut.rresp {gon_axi2apb_tb.axi_if[0].debug_rd_resp} gon_axi2apb_tb.dut.rlast gon_axi2apb_tb.dut.rvalid gon_axi2apb_tb.dut.rready }

set _session_group_6 Group6
gui_sg_create "$_session_group_6"
set Group6 "$_session_group_6"

gui_sg_addsignal -group "$_session_group_6" { gon_axi2apb_tb.dut.pclk gon_axi2apb_tb.dut.presetn gon_axi2apb_tb.dut.paddr gon_axi2apb_tb.dut.pwdata gon_axi2apb_tb.dut.pwrite gon_axi2apb_tb.dut.penable gon_axi2apb_tb.dut.psel_s0 gon_axi2apb_tb.dut.psel_s1 gon_axi2apb_tb.dut.psel_s2 gon_axi2apb_tb.dut.prdata_s0 gon_axi2apb_tb.dut.prdata_s1 gon_axi2apb_tb.dut.prdata_s2 }

set _session_group_7 Group7
gui_sg_create "$_session_group_7"
set Group7 "$_session_group_7"

gui_sg_addsignal -group "$_session_group_7" { gon_axi2apb_tb.apb_if.pclk gon_axi2apb_tb.apb_if.presetn }

set _session_group_8 Group8
gui_sg_create "$_session_group_8"
set Group8 "$_session_group_8"

gui_sg_addsignal -group "$_session_group_8" { {gon_axi2apb_tb.axi_if[0].AXI_ACLK} {gon_axi2apb_tb.axi_if[0].AXI_ARESET_N} }

# Global: Highlighting
gui_highlight_signals -color #00ff00 {{gon_axi2apb_tb.axi_if[0].drv_cb.AXI_ARLEN[3:0]}}

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 45500



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_create -id ${Wave.1} C2 1317767897
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 45500
gui_list_add_group -id ${Wave.1} -after {New Group} {Group1}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group2}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group3}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group4}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group5}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group6}
gui_list_select -id ${Wave.1} {gon_axi2apb_tb.dut.aresetn }
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group Group4  -item gon_axi2apb_tb.dut.aresetn -position below

gui_marker_move -id ${Wave.1} {C1} 45500
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

