//genesis

function iftest(arg)
   int arg
   if( arg == 0 )
      echo zero
   elif ( arg < 0 )
      echo negative
   else 
      echo positive
   end
end


iftest 0
iftest -1
iftest 1
