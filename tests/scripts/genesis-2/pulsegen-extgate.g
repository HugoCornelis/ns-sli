//genesis - pulsegen extgate
 

create pulsegen /pulse2
setfield ^ level1 50.0 width1 3.0 delay1 5.0 level2 -20.0 width2 5.0  \
    delay2 8.0 baselevel 10.0 trig_mode 2


create asc_file /pulse2_out 
setfield /pulse2_out    filename "pulse2.txt" flush 1  leave_open 1 append 1  float_format %0.9g
addmsg       /pulse2     /pulse2_out       SAVE output
call /pulse2_out OUT_OPEN

reset
setclock 0 0.5
step 200
