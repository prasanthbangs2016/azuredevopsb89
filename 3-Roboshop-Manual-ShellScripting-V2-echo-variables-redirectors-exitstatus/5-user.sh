source common.sh
component_name=user
echo Log file output: ${logfile} # this comes from common.sh



echo -e "${header_start} Download Nodejs ${header_end}" | tee -a ${logfile}
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &>>${logfile}
echo $?

echo -e "${header_start} Install Nodejs ${header_end}" | tee -a ${logfile}
dnf install -y nodejs &>>${logfile}
echo $?

echo -e "${header_start} Copy ${component_name} service file ${header_end}" | tee -a ${logfile}
cp user.service /etc/systemd/system/${component_name}.service &>>${logfile}
echo $?

echo -e "${header_start} Create appuser ${header_end}" | tee -a ${logfile}
useradd -r -s /bin/false appuser &>>${logfile}
echo $?

echo -e "${header_start} Create App folder ${header_end}" | tee -a ${logfile}
rm -rf /app &>>${logfile}
mkdir -p /app &>>${logfile}

echo -e "${header_start} Download ${component_name} code ${header_end}" | tee -a ${logfile}
curl -L -o /tmp/user.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip &>>${logfile}
echo $?

echo -e "${header_start} Extract ${component_name} code ${header_end}" | tee -a ${logfile}
cd /app &>>${logfile}
unzip /tmp/${component_name}.zip &>>${logfile}
echo $?

echo -e "${header_start} Compile the ${component_name} code ${header_end}" | tee -a ${logfile}
npm install --production &>>${logfile}

echo -e "${header_start} Apply permissions to app folder ${header_end}" | tee -a ${logfile}
chown -R appuser:appuser /app &>>${logfile}
chmod o-rwx /app -R &>>${logfile}
echo $?

echo -e "${header_start} Start ${component_name} ${header_end}" | tee -a ${logfile}
systemctl daemon-reload &>>${logfile}
systemctl enable user &>>${logfile}
systemctl restart user &>>${logfile}
echo $?


