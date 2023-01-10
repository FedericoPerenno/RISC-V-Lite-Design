onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb/clk_i
add wave -noupdate -format Logic /tb/sel_i
add wave -noupdate -format Logic /tb/rst_n_i
add wave -noupdate -format Literal /tb/din_instr_i
add wave -noupdate -format Literal -radix unsigned /tb/d_dm_i
add wave -noupdate -format Literal -radix unsigned /tb/add_dm_i
add wave -noupdate -format Logic /tb/wr_dm_i
add wave -noupdate -format Logic /tb/mem_read_i
add wave -noupdate -format Logic /tb/wr_im_i
add wave -noupdate -format Logic /tb/rd_im_i
add wave -noupdate -format Literal -radix unsigned /tb/add_im_i
add wave -noupdate -format Literal /tb/instruc_i
add wave -noupdate -format Literal /tb/dm/mem(28)
add wave -noupdate -format Literal /tb/dm/mem(29)
add wave -noupdate -format Literal /tb/dm/mem(30)
add wave -noupdate -format Literal /tb/dm/mem(31)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {413 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 74
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {1176 ns} {1405 ns}
