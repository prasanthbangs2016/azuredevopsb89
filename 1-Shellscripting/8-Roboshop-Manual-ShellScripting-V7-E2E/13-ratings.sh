source common.sh
component_name=ratings
echo Log file output: ${logfile}
schema_load=true
schema_type=mysql
schema_files="schema.sql app-user.sql"


echo -e "${header_start} Install python3 pip ${header_end}" | tee -a ${logfile}
dnf install -y python3 python3-pip &>>${logfile}
status_check

app_pre_reqs

schema_load

echo -e "${header_start} compile ${component_name} code ${header_end}" | tee -a ${logfile}
pip3 install -r /app/requirements.txt cryptography &>>${logfile}
status_check

systemd_service