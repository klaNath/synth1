onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /arb_test/clk
add wave -noupdate /arb_test/reset_n
add wave -noupdate /arb_test/wreq
add wave -noupdate /arb_test/fifo_full
add wave -noupdate /arb_test/memadrs
add wave -noupdate /arb_test/memdata
add wave -noupdate /arb_test/synth_ctrl
add wave -noupdate /arb_test/synth_data
add wave -noupdate -radix decimal /arb_test/test_state
add wave -noupdate -radix unsigned /arb_test/wait_cnt
add wave -noupdate -radix decimal /arb_test/arb1/state_reg
add wave -noupdate -radix unsigned /arb_test/arb1/wait_cnt
add wave -noupdate /arb_test/arb1/wreq_inter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2713 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 158
configure wave -valuecolwidth 52
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
WaveRestoreZoom {2676 ns} {2768 ns}
