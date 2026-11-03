source common.sh
componet_name=payment
echo Log file output: ${logfile}

echo -e "${header_start} Install python3 runtime and pip ${header_end}" | tee -a ${logfile}
dnf install -y python3 python3-pip &>>${logfile}
status_check

app_pre_reqs

echo -e "${header_start} Compile ${componet_name} code ${header_end}" | tee -a ${logfile}
pip3 install -r requirements.txt  &>>${logfile}
status_check

systemd_service