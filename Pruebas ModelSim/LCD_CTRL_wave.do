onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_cont/DUT/clk
add wave -noupdate /tb_cont/DUT/reset_l
add wave -noupdate /tb_cont/DUT/LCD_init_done
add wave -noupdate /tb_cont/DUT/OP_SETCURSOR
add wave -noupdate /tb_cont/DUT/OP_DRAWCOLOUR
add wave -noupdate /tb_cont/DUT/LCD_CS_N
add wave -noupdate /tb_cont/DUT/LCD_RS
add wave -noupdate /tb_cont/DUT/LCD_WR_N
add wave -noupdate -radix hexadecimal /tb_cont/DUT/LCD_DATA
add wave -noupdate /tb_cont/DUT/DONE_SETCURSOR
add wave -noupdate /tb_cont/DUT/DONE_DRAWCOLOR
add wave -noupdate /tb_cont/DUT/estado_q
add wave -noupdate -radix hexadecimal /tb_cont/DUT/NUMPIX
add wave -noupdate -radix hexadecimal /tb_cont/DUT/YROW
add wave -noupdate -radix hexadecimal /tb_cont/DUT/XCOL
add wave -noupdate -radix hexadecimal /tb_cont/DUT/RGB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1240000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 216
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {1110475 ps} {1352080 ps}
