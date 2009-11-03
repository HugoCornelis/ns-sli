/*======================================================================
  A GENESIS GUI with a simple control panel and graph, with axis scaling
  ======================================================================*/

include xtools.g    // functions to make "scale" buttons, etc.

//===============================
//      Function Definitions
//===============================

function overlaytoggle(widget)
    str widget
    setfield /##[TYPE=xgraph] overlay {getfield {widget} state}
end

function set_inject(dialog)
    str dialog
    setfield {cellpath}/soma inject {getfield {dialog} value}
end

function change_stepsize(dialog)
   str dialog
   dt =	 {getfield {dialog} value}
   setclock 0 {dt}
   echo "Changing step size to "{dt}
end

//===============================
//    Graphics Functions
//===============================

/* this depends on channel names defined in main script */
function set_soma_params
  gdens_Na = {getfield /soma_params/gdens_Na value}
  gdens_K = {getfield /soma_params/gdens_K value}
  setfield {cellpath}/soma/{Na_chan} Gbar {gdens_Na*SOMA_A}
  setfield {cellpath}/soma/{K_chan} Gbar {gdens_K*SOMA_A}
  Na_K_offset = {getfield /soma_params/Na_K_offset value}
  adjust_Na_K {Na_K_offset}
  Na_K_tau_scale = {getfield /soma_params/Na_K_tau_scale value}
  tau_scale {Na_K_tau_scale}
end


function make_control
  create xform /control [10,50,250,180]
  create xlabel /control/label -hgeom 25 -bg cyan -label "CONTROL PANEL"
  create xbutton /control/RESET -wgeom 33%       -script reset
  create xbutton /control/RUN  -xgeom 0:RESET -ygeom 0:label -wgeom 33% \
         -script step_tmax
  create xbutton /control/QUIT -xgeom 0:RUN -ygeom 0:label -wgeom 34% \
        -script quit
  create xdialog /control/stepsize -title "dt (sec)" -value {dt} \
                -script "change_stepsize <widget>"
  create xdialog /control/Injection -label "Injection (amperes)" \
                -value 0.5e-9 -script "set_inject <widget>"
  create xtoggle /control/overlay   -script "overlaytoggle <widget>"
  setfield /control/overlay offlabel "Overlay OFF" onlabel "Overlay ON" state 0
    create xbutton /control/soma_params -label "Soma Parameters" \
        -script "xshow /soma_params"
  xshow /control
end

function make_soma_params
  create xform /soma_params [20, 420, 250, 330]
  create xdialog /soma_params/gdens_Na -label "Na gdens (S/m^2)" \
        -value {gdens_Na}
  create xdialog /soma_params/gdens_K -label "K gdens (S/m^2)" \
        -value {gdens_K}
  create xdialog /soma_params/Na_K_offset -label "Na/Kdr offset (V)" \
        -value {Na_K_offset}
  create xdialog /soma_params/Na_K_tau_scale -label "Na/Kdr tau scaling" \
        -value {Na_K_tau_scale}
  create xbutton /soma_params/APPLY -wgeom 50% -script set_soma_params
  create xbutton /soma_params/Cancel -wgeom 50% -xgeom 0:APPLY	\
  	 -ygeom 0:Na_K_tau_scale -script "xhide /soma_params"
end

function make_Vmgraph
    float vmin = -0.100
    float vmax = 0.05
    create xform /data [265,50,700,350]
    create xlabel /data/label -hgeom 10% -label "Soma contains Na and K channels"
    create xgraph /data/voltage -hgeom 90% -title "Membrane Potential" -bg white
    setfield ^ XUnits sec YUnits Volts
    setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
    makegraphscale /data/voltage
    xshow /data
end

// Give the widgets more interesting colors
function colorize
    setfield /##[ISA=xlabel] fg white bg blue3
    setfield /##[ISA=xbutton] offbg rosybrown1 onbg rosybrown1
    setfield /##[ISA=xtoggle] onfg red offbg cadetblue1 onbg cadetblue1
    setfield /##[ISA=xdialog] bg palegoldenrod
    setfield /##[ISA=xgraph] bg ivory
end
