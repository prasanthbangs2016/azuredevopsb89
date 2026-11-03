source common.sh
component_name=notification
echo Log file output: ${logfile}


echo -e "${header_start} Install python3 pip ${header_end}" | tee -a ${logfile}
dnf install -y python3 python3-pip &>>${logfile}
status_check


app_pre_reqs
echo -e "${header_start} compile the ${component_name} code ${header_end}" | tee -a ${logfile}
pip3 install -r requirements.txt &>>${logfile}
status_check
systemd_service