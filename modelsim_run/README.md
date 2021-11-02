1. Make directory called `"work"`
    > `mkdir work`
1. Compile systemverilog from `"dotf"` file list.
    > `vlog.exe -f test_list.f`
1. Elaboration & simulation  
    - Simulate the Design without gui:  
    > `vsim.exe work.test_tb -c -do 'run -all'`  
    - Simulate the Design with gui 
    > `vsim.exe -gui work.test_tb`   

====The Commands=====
vlog.exe -f rvc_asap_list.f
vsim.exe work.rvc_asap_tb -c -do 'run -all'
vsim.exe -gui work.rvc_asap_tb
