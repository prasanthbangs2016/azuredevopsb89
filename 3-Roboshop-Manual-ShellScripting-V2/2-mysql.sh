source common.sh
component_name=mysql

&>>${logfile}


echo -e "${header_start} Install Mysql server runtime ${header_end}" | tee -a ${logfile}
dnf install -y mysql8.4-server &>>${logfile}
echo $?

echo -e "${header_start} Start Mysql server runtime ${header_end}" | tee -a ${logfile}
systemctl enable mysqld &>>${logfile}
systemctl start mysqld &>>${logfile}
echo $?

echo -e "${header_start} creating mysql user ${header_end}" | tee -a ${logfile}
mysql -u root -e "
  CREATE USER 'root'@'%' IDENTIFIED BY 'RoboShop@1';
  #create user is the if not exist only would be the failure so handled for the failure
  #CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'RoboShop@1';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
  ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';
  FLUSH PRIVILEGES;
" &>>${logfile}
echo $?

#mysql -u root -pRoboShop@1 -e "SHOW DATABASES;"

