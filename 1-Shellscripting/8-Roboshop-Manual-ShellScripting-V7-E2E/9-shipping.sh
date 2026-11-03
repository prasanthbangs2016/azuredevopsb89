source common.sh
component_name=shipping
echo Log file output: ${logfile}
schema_load=true
schema_type=mysql
schema_files="schema.sql app-user.sql"

start_time=$(date +%s)
echo "Start time ${start_time}"
end_time=$(date +%s)

echo -e "${header_start} Install JDK maven ${header_end}" | tee -a ${logfile}
dnf install -y java-21-openjdk java-21-openjdk-devel maven &>>${logfile
status_check

echo -e "${header_start} Copy ${component_name} service file ${header_end}" | tee -a ${logfile}
cp shipping.service /etc/systemd/system/shipping.service &>>${logfile
status_check

echo -e "${header_start} Download ${component_name} app code ${header_end}" | tee -a ${logfile}
curl -L -o /tmp/shipping.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/shipping.zip &>>${logfile}
status_check

echo -e "${header_start} Extract ${component_name} app code ${header_end}" | tee -a ${logfile}
rm -rf /app &>>${logfile}
mkdir -p /app &>>${logfile}
cd /app &>>${logfile}
unzip /tmp/shipping.zip &>>${logfile}
status_check

schema_load

echo -e "${header_start} Create appuser ${header_end}" | tee -a ${logfile}
  id appuser &>>${logfile}
  if [ $? -eq 1 ]; then
    useradd -r -s /bin/false appuser &>>${logfile}
  fi
  status_check

echo -e "${header_start} Compile the app code ${header_end}" | tee -a ${logfile}
cd /app &>>${logfile}
mvn clean package -DskipTests &>>${logfile}
cp target/shipping.jar /app/shipping.jar &>>${logfile}
status_check

echo -e "${header_start} Change appuser permissions ${header_end}" | tee -a ${logfile}
chown -R appuser:appuser /app &>>${logfile}
chmod o-rwx /app -R &>>${logfile}
status_check

echo -e "${header_start} Start ${component_name} ${header_end}" | tee -a ${logfile}
systemctl daemon-reload &>>${logfile}
systemctl enable shipping &>>${logfile}
systemctl start shipping &>>${logfile}
status_check

echo "end time ${end_time}"