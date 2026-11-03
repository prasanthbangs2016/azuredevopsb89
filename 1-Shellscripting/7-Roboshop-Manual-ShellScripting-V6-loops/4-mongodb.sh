source common.sh
component_name=mongodb
echo Log file output: ${logfile} #

echo -e "${header_start} copy ${component_name} repo file ${header_end}"
cp mongodb-org-7.0.repo /etc/yum.repos.d/mongodb-org-7.0.repo &>>${logfile}
echo $?

echo -e "${header_start} Install ${component_name} runtime ${header_end}"
dnf install -y mongodb-org &>>${logfile}
echo $?

echo -e "${header_start} Update ${component_name} config file ${header_end}"
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf &>>${logfile}
echo $?

echo -e "${header_start} Start ${component_name}  ${header_end}"
systemctl enable mongod &>>${logfile}
systemctl start mongod &>>${logfile}
echo $?