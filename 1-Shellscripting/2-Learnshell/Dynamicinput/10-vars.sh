#x=100 bash 10-vars.sh

echo x from left side of script - $x


#export y=200 #declare this variable
#bash 10-vars.sh
echo y from before script declared - $y

#bash 10-vars.sh 300

echo first argument to script : $1
echo first argument to script : $0
echo first argument to script : $#   # how many arguments i passed
echo first argument to script : $*  # to get all argument

#note : beyond $10, we should use flower bracket ${10}

#i will during runtime
read -p 'Enter z:' z
echo z from input - $z

#Note : read is least used option, not useful in automation
