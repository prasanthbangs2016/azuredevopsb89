source common.sh
component_name=catalogue

echo -e "${header_start} Install MYSQL client ${header_end}"
dnf install mysql8.4 -y &>>${log_file}
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

