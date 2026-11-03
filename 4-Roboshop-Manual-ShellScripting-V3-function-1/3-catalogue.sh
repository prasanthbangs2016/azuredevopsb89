source common.sh
component_name=catalogue
echo Log file output: ${logfile} # this comes from common.sh


echo -e "${header_start} Install mysql client ${header_end}" | tee -a ${logfile}
dnf install mysql8.4 -y &>>${logfile}
echo $?

app_pre_reqs

echo -e "${header_start} Load schema,App user and Master data ${header_end}" | tee -a ${logfile}
#below drop table is to avoid failure for every rerun
#mysql -h localhost -u root -pRoboShop@1 -e "DROP DATABASE IF EXISTS ${component_name};"
mysql -h localhost -u root -pRoboShop@1 < db/schema.sql &>>${logfile}
mysql -h localhost -u root -pRoboShop@1 < db/app-user.sql &>>${logfile}
mysql -h localhost -u root -pRoboShop@1 ${component_name} < db/master-data.sql &>>${logfile}
echo $?

golang_app

systemd_service
