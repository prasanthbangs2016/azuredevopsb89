log_file=/tmp/roboshop.log
header_start="\e[35m >>>>>>"
header_end="<<<<<< \e[0m"

echo -e "${header_start} Install  mysql repo file ${header_end}"
dnf install -y mysql8.4-server
systemctl enable mysqld
systemctl start mysqld

mysql -u root -e "
  CREATE USER 'root'@'%' IDENTIFIED BY 'RoboShop@1';
  #create user is the if not exist only would be the failure so handled for the failure
  #CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'RoboShop@1';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
  ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';
  FLUSH PRIVILEGES;
"

#mysql -u root -pRoboShop@1 -e "SHOW DATABASES;"

