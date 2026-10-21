logfile=/tmp/roboshop.log
header_start="\e[35m >>>>>>"
header_end=">>>>>> \e[0m"


echo -e "${header_start} copy mongo repo file ${header_end}"
cp mongodb-org-7.0.repo /etc/yum.repos.d/mongodb-org-7.0.repo &>>${logfile}
echo $?

echo -e "${header_start} Install mongo ${header_end}"
dnf install -y mongodb-org &>>${logfile}
echo $?


echo -e "${header_start} Update mongo conf for bind internet ${header_end}"
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
echo $?

echo -e "${header_start} Start mongo service ${header_end}"
systemctl enable mongod
systemctl start mongod &>>${logfile}
echo $?