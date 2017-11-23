
#date | awk '{Report created at: $0}' >> report.log
#echo '' >> report.log
#echo '' >> report.log
#echo '' >> report.log

echo "---------------  log ERROR/WANRING info ---------------" > report.log
grep '*W' test_*/*/*.log >> report.log
grep '*E' test_*/*/*.log >> report.log
echo "------------------  log FAILED info -------------------" >> report.log
grep '[Ff]ailed' test_*/*/*.log >> report.log

