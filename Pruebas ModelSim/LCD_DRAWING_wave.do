onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_draw/DUT/clk
add wave -noupdate /tb_draw/DUT/reset_l
add wave -noupdate /tb_draw/DUT/DEL_SCREEN
add wave -noupdate /tb_draw/DUT/DRAW_DIAG
add wave -noupdate /tb_draw/DUT/COLOUR
add wave -noupdate /tb_draw/DUT/DONE_SETCURSOR
add wave -noupdate /tb_draw/DUT/DONE_DRAWCOLOR
add wave -noupdate /tb_draw/DUT/OP_SETCURSOR
add wave -noupdate /tb_draw/DUT/XCOL
add wave -noupdate /tb_draw/DUT/YROW
add wave -noupdate /tb_draw/DUT/OP_DRAWCOLOUR
add wave -noupdate /tb_draw/DUT/RGB
add wave -noupdate /tb_draw/DUT/NUMPIX
add wave -noupdate /tb_draw/DUT/estado_q
add wave -noupdate /tb_draw/DUT/estado_d
add wave -noupdate /tb_draw/DUT/cont_x
add wave -noupdate /tb_draw/DUT/cont_y
add wave -noupdate /tb_draw/DUT/EN_CONT_X
add wave -noupdate /tb_draw/DUT/EN_CONT_Y
add wave -noupdate /tb_draw/DUT/RES_CONT_X
add wave -noupdate /tb_draw/DUT/RES_CONT_Y
add wave -noupdate /tb_draw/DUT/color
add wave -noupdate /tb_draw/DUT/num_pix
add wave -noupdate /tb_draw/DUT/LD_REG_COLOR
add wave -noupdate /tb_draw/DUT/LD_NUMPIX_5
add wave -noupdate /tb_draw/DUT/LD_NUMPIX_A
add wave -noupdate /tb_draw/DUT/RS_NUMPIX
add wave -noupdate /tb_draw/DUT/LD_COLOR_N
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {166328 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 217
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
WaveRestoreZoom {152762 ps} {329914 ps}
