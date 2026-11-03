source common.sh
componet_name=payment
echo Log file output: ${logfile}

echo -e "${header_start} Install python3 runtime and pip ${header_end}" | tee -a ${logfile}
dnf install -y python3 python3-pip &>>${logfile}
status_check

echo -e "${header_start} Copy ${componet_name} service file ${header_end}" | tee -a ${logfile}
cp payment.service /etc/systemd/system/payment.service &>>${logfile}
status_check


echo -e "${header_start} Create appuser ${header_end}" | tee -a ${logfile}
  id appuser &>>${logfile}
  if [ $? -eq 1 ]; then
    useradd -r -s /bin/false appuser &>>${logfile}
  fi
  status_check

echo -e "${header_start} create folder for ${component_name} ${header_end}" | tee -a ${logfile}
rm -rf /app &>>${logfile}
mkdir -p /app &>>${logfile}
status_check
cd /app &>>${logfile}


echo -e "${header_start} Download ${componet_name} code ${header_end}" | tee -a ${logfile}
curl -L -o /tmp/${component_name}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip &>>${logfile}
status_check

echo -e "${header_start} Extract ${componet_name} code ${header_end}" | tee -a ${logfile}
unzip /tmp/${component_name}.zip &>>${logfile}
status_check

echo -e "${header_start} Compile ${componet_name} code ${header_end}" | tee -a ${logfile}
pip3 install -r requirements.txt  &>>${logfile}
status_check

systemd_service