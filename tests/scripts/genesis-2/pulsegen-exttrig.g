//genesis - demonstration of pulsegen ext trigger
 


create pulsegen /pulse1
setfield ^ level1 50.0 width1 3.0 delay1 5.0 level2 -20.0 width2 5.0  \
    delay2 8.0 baselevel 10.0 trig_mode 1




create asc_file /pulse1_out 
setfield /pulse1_out    filename "pulse1.txt" flush 1  leave_open 1 append 1  float_format %0.9g
addmsg       /pulse1     /pulse1_out       SAVE output
call /pulse1_out OUT_OPEN


reset
setclock 0 0.5
step 200
