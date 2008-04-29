setclock 0 0.000003
create compartment c
setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
// create hsolve h
// setmethod h 11
// setfield h \
// 	chanmode 4 \
// 	path /c
// call h SETUP
reset

function add_squid_electronics

    // Electronics for voltage and current clamp 

    create pulsegen /pulsegen
    setfield ^ level1 25.0 width1 50.0 delay1 2.0 delay2 999.0  \
        trig_mode 1.0 trig_time 0.0

    setfield ^ x 0.000003

    // changed time constant from 0.1 msec to 0.03 msec for sharper Vclamp pulse
    create RC /lowpass
    setfield ^ R 1.0 C 0.00003
//     setfield ^ R 1.0e9 C 0.00003

//     create diffamp /Iclamp
//     setfield ^ saturation 999.0 gain 0.0

    create diffamp /Vclamp
    setfield ^ saturation 999.0 gain 1.0
//     setfield ^ saturation 1e-3 gain 1.0

    create PID /PID
    setfield ^ gain 0.50 tau_i 0.000003 tau_d {0.000003 / 4} saturation 999.0
//     setfield ^ gain 0.50 tau_i 0.000003 tau_d {0.000003 / 4} saturation 1.0e-6
end


function connect_squid_electronics(path)
    str path

    // hook up current clamp circuitry

//     addmsg /pulsegen /Iclamp PLUS output
//     addmsg /Iclamp {path} INJECT output


    // hook up voltage clamp circuitry

    addmsg /pulsegen /lowpass INJECT output

    addmsg /pulsegen /lowpass INJECT x

    addmsg /lowpass /Vclamp PLUS state
    addmsg /Vclamp /PID CMD output
    addmsg {path} /PID SNS Vm
    addmsg /PID {path} INJECT output
end

function showfields

	showfield h \
		results[0] \
		results[1] \
		vm[0]
end

add_squid_electronics

connect_squid_electronics c

