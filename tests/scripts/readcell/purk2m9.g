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
  readcell ../tests/scripts/readcell/Purk2M9-nospines.p /test

// addmsg /test/Purk_soma plot_out SAVE Vm



silent 1
//call plot_out RESET

reset


set_nsintegrator_verbose_level 2


echo Initiated



echo -------
echo Iteration 0

step 100

echo -------
echo Iteration 1

//step 100

echo -------
echo Iteration 2

//step 100

echo -------
echo Iteration 3

//step 100

echo -------
echo Iteration 4

//step 100

echo -------
echo Iteration 5

//step 100

echo -------
echo Iteration 6

//step 100

echo -------
echo Iteration 7

//step 100

echo -------
echo Iteration 8

//step 100

echo -------
echo Iteration 9

//step 100


//step 9000

//step 15000




//call plot_out FINISH


//echo output written

//exit

call model_container NEUROSPACES_QUERY








