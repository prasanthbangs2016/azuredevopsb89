source common.sh
component_name=catalogue


app_pre_req

echo -e "${header_start} Install MYSQL client ${header_end}"
dnf install mysql8.4 -y &>>${log_file}
echo $?



echo -e "${header_start} Loading DB schemas ${header_end}"

#below drop table is to avoid failure for every rerun
#mysql -h localhost -u root -pRoboShop@1 -e "DROP DATABASE IF EXISTS catalogue;"
mysql -h localhost -u root -pRoboShop@1 < db/schema.sql
mysql -h localhost -u root -pRoboShop@1 < db/app-user.sql
mysql -h localhost -u root -pRoboShop@1 catalogue < db/master-data.sql
echo $?

golang_app
systemd_service

