source common.sh
component_name=catalogue
echo Log file output: ${logfile} # this comes from common.sh

echo -e "${header_start} installing Golang GIT & Mysql ${header_end}" | tee -a ${logfile}
dnf install -y golang git mysql8.4 &>>${logfile}
echo $?


echo -e "${header_start} Copy ${component_name} service file ${header_end}" | tee -a ${logfile}
cp ${component_name}.service /etc/systemd/system/${component_name}.service &>>${logfile}
echo $?

echo -e "${header_start} Download ${component_name} code ${header_end}" | tee -a ${logfile}
curl -L -o /tmp/${component_name}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip &>>${logfile}
echo $?

echo -e "${header_start} create folder for ${component_name} ${header_end}" | tee -a ${logfile}
rm -rf /app &>>${logfile}
mkdir -p /app &>>${logfile}
echo $?
cd /app

echo -e "${header_start} Extract ${component_name} content ${header_end}" | tee -a ${logfile}
unzip /tmp/${component_name}.zip &>>${logfile}
echo $?

echo -e "${header_start} Load schema,App user and Master data ${header_end}" | tee -a ${logfile}
#below drop table is to avoid failure for every rerun
#mysql -h localhost -u root -pRoboShop@1 -e "DROP DATABASE IF EXISTS ${component_name};"
mysql -h localhost -u root -pRoboShop@1 < db/schema.sql &>>${logfile}
mysql -h localhost -u root -pRoboShop@1 < db/app-user.sql &>>${logfile}
mysql -h localhost -u root -pRoboShop@1 ${component_name} < db/master-data.sql &>>${logfile}
echo $?

echo -e "${header_start} Create application user ${header_end}" | tee -a ${logfile}
# Create the app user only if it does not exist
useradd -r -s /bin/false appuser &>>${logfile}
echo $?
#if ! id appuser >/dev/null 2>&1; then
#  useradd -r -s /bin/false appuser
#fi
cd /app

echo -e "${header_start} Compile application code ${header_end}" | tee -a ${logfile}
go mod tidy
CGO_ENABLED=0 go build -o /app/${component_name} . &>>${logfile}
echo $?

echo -e "${header_start} Apply permissions to app folder ${header_end}" | tee -a ${logfile}
chown -R appuser:appuser /app &>>${logfile}
chmod o-rwx /app -R &>>${logfile}
echo $?

echo -e "${header_start} Start ${component_name} ${header_end}" | tee -a ${logfile}
systemctl daemon-reload &>>${logfile}
systemctl enable ${component_name} &>>${logfile}
systemctl start ${component_name} &>>${logfile}
echo $?
