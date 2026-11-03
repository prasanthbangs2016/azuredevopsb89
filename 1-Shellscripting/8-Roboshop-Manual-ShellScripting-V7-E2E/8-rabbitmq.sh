source common.sh
component_name=rabbitmq
echo Log file output: ${logfile}

&>>${logfile}

echo -e "${header_start} Copy ${component_name} repo file ${header_end}" | tee -a ${logfile}
cp ${rabbitmq}.repo /etc/yum.repos.d/${rabbitmq}.repo &>>${logfile}
status_check

echo -e "${header_start} install ${component_name} Server runtime ${header_end}" | tee -a ${logfile}
dnf install -y ${rabbitmq}-server erlang &>>${logfile}
status_check


echo -e "${header_start} Start ${component_name} Service ${header_end}" | tee -a ${logfile}
systemctl enable ${rabbitmq}-server &>>${logfile}
systemctl start ${rabbitmq}-server &>>${logfile}
status_check

echo -e "${header_start} Install ${component_name} Plugins enable ${header_end}" | tee -a ${logfile}
${rabbitmq}-plugins enable ${rabbitmq}_management &>>${logfile}
status_check

systemctl restart ${rabbitmq}-server &>>${logfile}

echo -e "${header_start} ${component_name} adding user setting roboshop user and set set_permissionsss ${header_end}" | tee -a ${logfile}
${rabbitmq}ctl add_user roboshop RoboShop@1 &>>${logfile}
${rabbitmq}ctl set_user_tags roboshop administrator &>>${logfile}
${rabbitmq}ctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${logfile}
status_check

systemctl status ${rabbitmq}-server &>>${logfile}
status_check
