//genesis - demonstration of pulsegen freerun
 
create pulsegen /pulse0
setfield ^ level1 50.0 width1 3.0 delay1 5.0 level2 -20.0 width2 5.0  \
    delay2 8.0 baselevel 10.0 trig_mode 0



create asc_file /pulse0_out 
setfield /pulse0_out    filename "pulse0.txt" flush 1  leave_open 1 append 1  float_format %0.9g
addmsg       /pulse0     /pulse0_out       SAVE output
call /pulse0_out OUT_OPEN

reset
setclock 0 0.5
step 200
