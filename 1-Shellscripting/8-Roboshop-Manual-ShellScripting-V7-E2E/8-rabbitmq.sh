source common.sh
component_name=rabbitmq
echo Log file output: ${logfile}

echo -e "${header_start} Copy ${component_name} repo file ${header_end}" | tee -a ${logfile}
cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>${logfile}
status_check

echo -e "${header_start} install ${component_name} Server runtime ${header_end}" | tee -a ${logfile}
dnf install -y ${component_name}-server erlang &>>${logfile}
status_check


echo -e "${header_start} Start ${component_name} Service ${header_end}" | tee -a ${logfile}
systemctl enable ${component_name}-server &>>${logfile}
systemctl start ${component_name}-server &>>${logfile}
status_check

echo -e "${header_start} Install ${component_name} Plugins enable ${header_end}" | tee -a ${logfile}
${component_name}-plugins enable ${component_name}_management &>>${logfile}
status_check

systemctl restart ${component_name}-server &>>${logfile}

echo -e "${header_start} ${component_name} adding user setting roboshop user and set set_permissionsss ${header_end}" | tee -a ${logfile}
${component_name}ctl add_user roboshop RoboShop@1 &>>${logfile}
${component_name}ctl set_user_tags roboshop administrator &>>${logfile}
${component_name}ctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${logfile}
status_check


