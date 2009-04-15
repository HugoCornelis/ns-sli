//genesis

float dt = 2e-7
setclock 0 {dt}
addglobal float EREST_ACT
addglobal float ELEAK 
setglobal EREST_ACT -0.08
setglobal ELEAK -0.01

  create neutral /library
  create compartment /library/compartment


  create asc_file plot_out
  setfield /plot_out \
	append 0 \
	filename "results.out" \
	flush 1 \
	leave_open 1 

  echo Performing readcell
  readcell ../tests/scripts/readcell/cell.p /test

  addmsg /test/soma plot_out SAVE Vm

  call plot_out RESET 

  echo done!




silent 1

reset

set_nsintegrator_verbose_level 2


echo Initiated



echo -------
echo Iteration 0

step 1

echo -------
echo Iteration 1

step 1

echo -------
echo Iteration 2

step 1

echo -------
echo Iteration 3

step 1

echo -------
echo Iteration 4

step 1

echo -------
echo Iteration 5

step 1

echo -------
echo Iteration 6

step 1

echo -------
echo Iteration 7

step 1

echo -------
echo Iteration 8

step 1

echo -------
echo Iteration 9

step 1










