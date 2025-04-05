# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Sat Apr 5 11:14:57 2025
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 59 signals
# End_DVE_Session_Save_Info

# DVE version: O-2018.09-1_Full64
# DVE build date: Oct 12 2018 21:19:11


#<Session mode="View" path="/home/ICer/ic_prjs/AXI2APB/sim/gon_axi2apb_debug_wave.do" type="Debug">

#<Database>

gui_set_time_units 10ps
#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Sat Apr 5 11:14:57 2025
# 59 signals
# End_DVE_Session_Save_Info

# DVE version: O-2018.09-1_Full64
# DVE build date: Oct 12 2018 21:19:11


#Add ncecessay scopes
gui_load_child_values {gon_axi2apb_tb.dut}

gui_set_time_units 10ps

set _wave_session_group_1 Group1
if {[gui_sg_is_group -name "$_wave_session_group_1"]} {
    set _wave_session_group_1 [gui_sg_generate_new_name]
}
set Group1 "$_wave_session_group_1"

gui_sg_addsignal -group "$_wave_session_group_1" { {Sim:gon_axi2apb_tb.dut.aclk} {Sim:gon_axi2apb_tb.dut.aresetn} {Sim:gon_axi2apb_tb.dut.awid} {Sim:gon_axi2apb_tb.dut.awaddr} {Sim:gon_axi2apb_tb.dut.awlen} {Sim:gon_axi2apb_tb.axi_if[0].debug_wr_length} {Sim:gon_axi2apb_tb.dut.awsize} {Sim:gon_axi2apb_tb.axi_if[0].debug_wr_size} {Sim:gon_axi2apb_tb.dut.awburst} {Sim:gon_axi2apb_tb.axi_if[0].debug_wr_type} {Sim:gon_axi2apb_tb.dut.awcache} {Sim:gon_axi2apb_tb.dut.awprot} {Sim:gon_axi2apb_tb.dut.awlock} {Sim:gon_axi2apb_tb.dut.awvalid} {Sim:gon_axi2apb_tb.dut.awready} }

set _wave_session_group_2 Group2
if {[gui_sg_is_group -name "$_wave_session_group_2"]} {
    set _wave_session_group_2 [gui_sg_generate_new_name]
}
set Group2 "$_wave_session_group_2"

gui_sg_addsignal -group "$_wave_session_group_2" { {Sim:gon_axi2apb_tb.dut.wid} {Sim:gon_axi2apb_tb.dut.wdata} {Sim:gon_axi2apb_tb.dut.wstrb} {Sim:gon_axi2apb_tb.dut.wlast} {Sim:gon_axi2apb_tb.dut.wvalid} {Sim:gon_axi2apb_tb.dut.wready} }

set _wave_session_group_3 Group3
if {[gui_sg_is_group -name "$_wave_session_group_3"]} {
    set _wave_session_group_3 [gui_sg_generate_new_name]
}
set Group3 "$_wave_session_group_3"

gui_sg_addsignal -group "$_wave_session_group_3" { {Sim:gon_axi2apb_tb.dut.bid} {Sim:gon_axi2apb_tb.dut.bresp} {Sim:gon_axi2apb_tb.axi_if[0].debug_wr_resp} {Sim:gon_axi2apb_tb.dut.bvalid} {Sim:gon_axi2apb_tb.dut.bready} }

set _wave_session_group_4 Group4
if {[gui_sg_is_group -name "$_wave_session_group_4"]} {
    set _wave_session_group_4 [gui_sg_generate_new_name]
}
set Group4 "$_wave_session_group_4"

gui_sg_addsignal -group "$_wave_session_group_4" { {Sim:gon_axi2apb_tb.dut.arid} {Sim:gon_axi2apb_tb.dut.araddr} {Sim:gon_axi2apb_tb.dut.arlen} {Sim:gon_axi2apb_tb.axi_if[0].debug_rd_length} {Sim:gon_axi2apb_tb.dut.arsize} {Sim:gon_axi2apb_tb.axi_if[0].debug_rd_size} {Sim:gon_axi2apb_tb.dut.arburst} {Sim:gon_axi2apb_tb.axi_if[0].debug_rd_type} {Sim:gon_axi2apb_tb.dut.arcache} {Sim:gon_axi2apb_tb.dut.arprot} {Sim:gon_axi2apb_tb.dut.arlock} {Sim:gon_axi2apb_tb.dut.arvalid} {Sim:gon_axi2apb_tb.dut.arready} }

set _wave_session_group_5 Group5
if {[gui_sg_is_group -name "$_wave_session_group_5"]} {
    set _wave_session_group_5 [gui_sg_generate_new_name]
}
set Group5 "$_wave_session_group_5"

gui_sg_addsignal -group "$_wave_session_group_5" { {Sim:gon_axi2apb_tb.dut.rid} {Sim:gon_axi2apb_tb.dut.rdata} {Sim:gon_axi2apb_tb.dut.rresp} {Sim:gon_axi2apb_tb.axi_if[0].debug_rd_resp} {Sim:gon_axi2apb_tb.dut.rlast} {Sim:gon_axi2apb_tb.dut.rvalid} {Sim:gon_axi2apb_tb.dut.rready} }

set _wave_session_group_6 Group6
if {[gui_sg_is_group -name "$_wave_session_group_6"]} {
    set _wave_session_group_6 [gui_sg_generate_new_name]
}
set Group6 "$_wave_session_group_6"

gui_sg_addsignal -group "$_wave_session_group_6" { {Sim:gon_axi2apb_tb.dut.pclk} {Sim:gon_axi2apb_tb.dut.presetn} {Sim:gon_axi2apb_tb.dut.paddr} {Sim:gon_axi2apb_tb.dut.pwdata} {Sim:gon_axi2apb_tb.dut.pwrite} {Sim:gon_axi2apb_tb.dut.penable} {Sim:gon_axi2apb_tb.dut.psel_s0} {Sim:gon_axi2apb_tb.dut.psel_s1} {Sim:gon_axi2apb_tb.dut.psel_s2} {Sim:gon_axi2apb_tb.dut.prdata} {Sim:gon_axi2apb_tb.dut.prdata_s0} {Sim:gon_axi2apb_tb.dut.prdata_s1} {Sim:gon_axi2apb_tb.dut.prdata_s2} }
if {![info exists useOldWindow]} { 
	set useOldWindow true
}
if {$useOldWindow && [string first "Wave" [gui_get_current_window -view]]==0} { 
	set Wave.1 [gui_get_current_window -view] 
} else {
	set Wave.1 [lindex [gui_get_window_ids -type Wave] 0]
if {[string first "Wave" ${Wave.1}]!=0} {
gui_open_window Wave
set Wave.1 [ gui_get_current_window -view ]
}
}

set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 40408 68585
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group1}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group2}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group3}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group4}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group5}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group6}]
gui_list_select -id ${Wave.1} {gon_axi2apb_tb.dut.bready }
gui_seek_criteria -id ${Wave.1} {Any Edge}


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
gui_list_set_insertion_bar  -id ${Wave.1} -group ${Group1}  -item {gon_axi2apb_tb.dut.awlen[3:0]} -position below

gui_marker_move -id ${Wave.1} {C1} 54500
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
#</Session>

