##assertion -strict on
assertion -style -multiline
assertion -logging -all  -state failed
assertion -summary -final gpio_int_top_tb.ast_gpio_int_intf_inst -directive assert -redirect assertion_summary.txt
run
