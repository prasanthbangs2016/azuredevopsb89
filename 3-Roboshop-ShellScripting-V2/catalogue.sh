source common.sh
component_name=catalogue

echo -e "${header_start} Install MYSQL client ang golang ${header_end}"
dnf install golang mysql8.4 -y &>>${log_file}
echo $?

echo -e "${header_start} copy ${component_name} service file ${header_end}"
cp ${component_name}.service /etc/systemd/system/${component_name}.service &>>${log_file}
echo $?


echo -e "${header_start} Download ${component_name} code ${header_end}"
curl -L -o /tmp/${component_name}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip &>>/${log_file}
echo $?


echo -e "${header_start} Creating directory for ${component_name} ${header_end}"
rm -rf /app &>>${log_file}
mkdir -p /app &>>${log_file}

cd /app

echo -e "${header_start} ${component_name} code Extraction ${header_end}"
unzip /tmp/${component_name}.zip &>>${log_file}
echo $?

echo -e "${header_start} Loading DB schemas ${header_end}"

#below drop table is to avoid failure for every rerun
#mysql -h localhost -u root -pRoboShop@1 -e "DROP DATABASE IF EXISTS catalogue;"
mysql -h localhost -u root -pRoboShop@1 < db/schema.sql &>>${log_file}
mysql -h localhost -u root -pRoboShop@1 < db/app-user.sql &>>${log_file}
mysql -h localhost -u root -pRoboShop@1 ${component_name} < db/master-data.sql &>>${log_file}
echo $?

echo -e "${header_start} Creating application user ${header_end}"
useradd -r -s /bin/false appuser &>>${log_file}
echo $?

echo -e "${header_start} Compile the code ${header_end}"
go mod tidy &>>${log_file}
CGO_ENABLED=0 go build -o /app/${component_name} . &>>${log_file}
echo $?

echo -e "${header_start} Start Service ${header_end}"
systemctl daemon-reload
systemctl enable ${component_name}
systemctl restart ${component_name} &>>${log_file}
echo $?






