while we used when we have expression
x=10

#it is intfine loop
#while [ $x -lt 0 ]; do
  #echo Hello
#done


#now this code block will print 10time
while [ $x -lt 0 ]; do
  echo Hello
  x=$(($x-1)) #here controlling the x with condition
done




