source common.sh
component_name=orders
echo Log file output: ${logfile}

echo -e "${header_start} Install JDK maven ${header_end}" | tee -a ${logfile}
dnf install -y java-21-openjdk java-21-openjdk-devel maven &>>${logfile}
status_check

app_pre_reqs

echo -e "${header_start} compile ${component_name} ${header_end}" | tee -a ${logfile}
mvn clean package -DskipTests &>>${logfile}
cp target/orders.jar /app/orders.jar &>>${logfile}
status_check


systemd_service