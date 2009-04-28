//genesis

float dt = 2e-7
setclock 0 {dt}
addglobal float RM
addglobal float RA
addglobal float CM
addglobal float ELEAK 
addglobal float EREST_ACT


setglobal RM 3.58441e8
setglobal RA 360502
setglobal CM 4.57537e-1

//
// 
//
setglobal EREST_ACT -0.08
setglobal ELEAK -0.01

  create neutral library

  create compartment /library/compartment

  create compartment /library/Purk_soma

  create compartment /library/Purk_maind

  create compartment /library/Purk_thickd

  create compartment /library/Purk_spinyd



  create asc_file plot_out
  setfield /plot_out \
	append 0 \
	filename "/tmp/purk2m9_Vm.txt" \
	flush 1 \
	leave_open 1 

  echo Performing readcell
  readcell tests/scripts/readcell/Purk2M9-nospines.p /test

addmsg /test/soma plot_out SAVE Vm



silent 1
call plot_out RESET

reset




echo Initiated


step 25000



call plot_out FINISH


echo output written



call model_container NEUROSPACES_QUERY








