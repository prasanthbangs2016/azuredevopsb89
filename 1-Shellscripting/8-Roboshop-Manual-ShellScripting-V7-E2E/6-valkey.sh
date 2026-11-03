source common.sh
component_name=valkey
echo Log file output: ${logfile} #

echo -e "${header_start} Install ${component_name} ${header_end}"
dnf install -y valkey &>>${logfile}
status_check

echo -e "${header_start} Update ${component_name} config file ${header_end}"
sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/${component_name}/${component_name}.conf &>>${logfile}
sed -i 's/protected-mode yes/protected-mode no/' /etc/${component_name}/${component_name}.conf &>>${logfile}
status_check

echo -e "${header_start} Start ${component_name} service ${header_end}"
systemctl enable ${component_name} &>>${logfile}
systemctl start ${component_name} &>>${logfile}
status_check