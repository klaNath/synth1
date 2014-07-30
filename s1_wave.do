onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synth1_test/s1/wwreq2arb
add wave -noupdate /synth1_test/s1/memadrs
add wave -noupdate /synth1_test/s1/memdata
add wave -noupdate /synth1_test/clk
add wave -noupdate /synth1_test/reset_n
add wave -noupdate /synth1_test/s1/clr_n
add wave -noupdate /synth1_test/s1/data
add wave -noupdate -max 65530.999999999993 -radix decimal /synth1_test/s1/fifo_in
add wave -noupdate /synth1_test/s1/synth_ctrl
add wave -noupdate /synth1_test/s1/synth_data
add wave -noupdate -max 2097129.9999999998 -radix unsigned /synth1_test/s1/operator_1/phase_1
add wave -noupdate -radix unsigned /synth1_test/s1/arbiter/state_reg
add wave -noupdate /synth1_test/s1/wrreq
add wave -noupdate /synth1_test/s1/rdreq
add wave -noupdate /synth1_test/s1/full
add wave -noupdate /synth1_test/s1/empty
add wave -noupdate /synth1_test/s1/lrck
add wave -noupdate /synth1_test/s1/sdo
add wave -noupdate /synth1_test/s1/bck
add wave -noupdate /synth1_test/s1/lj24tx/audio_buf_a
add wave -noupdate /synth1_test/s1/lj24tx/audio_buf_b
add wave -noupdate /synth1_test/s1/lj24tx/tx_cnt
add wave -noupdate -format Analog-Step -height 74 -max 32762.0 -min -32767.0 -radix decimal /synth1_test/s1/operator_1/data_out
add wave -noupdate /synth1_test/s1/spi_rx/rx_valid
add wave -noupdate /synth1_test/s1/spi_rx/rx_buf2
add wave -noupdate /synth1_test/s1/spi_rx/rx_cnt
add wave -noupdate /synth1_test/shift_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 232
configure wave -valuecolwidth 233
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
WaveRestoreZoom {0 ps} {34176 ps}
