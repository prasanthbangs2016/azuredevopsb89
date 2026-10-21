source common.sh
component_name=catalogue

echo -e "${header_start} Install MYSQL client ${header_end}"
dnf install mysql8.4 -y &>>${log_file}
echo $?

echo -e "${header_start} Creating DB user ${header_end}"
mysql -u root -e "
  CREATE USER 'root'@'%' IDENTIFIED BY 'RoboShop@1';
  #create user is the if not exist only would be the failure so handled for the failure
  #CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'RoboShop@1';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
  ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';
  FLUSH PRIVILEGES; &>>${log_file}
"
systemctl enable mysqld
systemctl start mysqld &>>${log_file}
echo $?

app_pre_reqs

echo -e "${header_start} Loading DB schemas ${header_end}"

#below drop table is to avoid failure for every rerun
#mysql -h localhost -u root -pRoboShop@1 -e "DROP DATABASE IF EXISTS catalogue;"
mysql -h localhost -u root -pRoboShop@1 < db/schema.sql &>>${log_file}
mysql -h localhost -u root -pRoboShop@1 < db/app-user.sql &>>${log_file}
mysql -h localhost -u root -pRoboShop@1 ${component_name} < db/master-data.sql &>>${log_file}
echo $?

golang_app
systemd_service

