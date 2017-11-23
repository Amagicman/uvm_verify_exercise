sh rm -rf ./cov_work/scope/merge_code
load_test cov_work/scope/*
define COV_LOGDIR ./log/cov
test_order -b -e > $COV_LOGDIR/coverage_test_order.log
union merge_code
report_summary -instance -besaftd gpio_int_top_tb... > $COV_LOGDIR/cov_summary.log
report_html    -instance -besftd *... -output $COV_LOGDIR/my_html_rpt
report_detail  -instance -uncovered -besaftd *... > $COV_LOGDIR/uncovered_summary.log
exit
