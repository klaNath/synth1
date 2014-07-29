onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Analog-Step -height 74 -max 2097119.9999999998 -radix unsigned /sine_test/phase_21
add wave -noupdate -format Analog-Step -height 74 -max 32767.0 -min -32767.0 /sine_test/sine_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {999435 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {997461 ns} {1000134 ns}
