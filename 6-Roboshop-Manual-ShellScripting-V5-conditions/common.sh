logfile=/tmp/roboshop.log
header_start="\e[35m >>>>>>"
header_end=">>>>>> \e[0m"

app_pre_reqs() {
  echo -e "${header_start} Copy ${component_name} service file ${header_end}" | tee -a ${logfile}
  cp ${component_name}.service /etc/systemd/system/${component_name}.service &>>${logfile}
  status_check

#adding idempotency that to avoid already exist error
  echo -e "${header_start} Create appuser ${header_end}" | tee -a ${logfile}
  id appuser &>>${logfile}
#here 1 means not present ,check for useradd command exit status code in google
  if [ $? -eq 1 ]; then
    useradd -r -s /bin/false appuser &>>${logfile}
  fi
  status_check

  echo -e "${header_start} Download ${component_name} code ${header_end}" | tee -a ${logfile}
  curl -L -o /tmp/${component_name}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip &>>${logfile}
  status_check

  echo -e "${header_start} create folder for ${component_name} ${header_end}" | tee -a ${logfile}
  rm -rf /app &>>${logfile}
  mkdir -p /app &>>${logfile}
  status_check
  cd /app

  echo -e "${header_start} Extract ${component_name} content ${header_end}" | tee -a ${logfile}
  unzip /tmp/${component_name}.zip &>>${logfile}
  status_check
}

nodejs_app() {
  app_pre_reqs

  echo -e "${header_start} Download Nodejs ${header_end}" | tee -a ${logfile}
  curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &>>${logfile}
  status_check

  echo -e "${header_start} Install Nodejs ${header_end}" | tee -a ${logfile}
  dnf install -y nodejs &>>${logfile}
  status_check

  echo -e "${header_start} Download App dependencies ${component_name} code ${header_end}" | tee -a ${logfile}
  npm install --production &>>${logfile}
  systemd_service
}

systemd_service() {
  schema_load

  echo -e "${header_start} Apply permissions to app folder ${header_end}" | tee -a ${logfile}
  chown -R appuser:appuser /app &>>${logfile}
  chmod o-rwx /app -R &>>${logfile}
  status_check

  echo -e "${header_start} Start ${component_name} ${header_end}" | tee -a ${logfile}
  systemctl daemon-reload &>>${logfile}
  systemctl enable ${component_name} &>>${logfile}
  systemctl start ${component_name} &>>${logfile}
  status_check
}

golang_app() {
  app_pre_reqs

  echo -e "${header_start} installing Golang GIT ${header_end}" | tee -a ${logfile}
  dnf install -y golang git  &>>${logfile}
  status_check

  echo -e "${header_start} Compile application code ${header_end}" | tee -a ${logfile}
  go mod tidy &>>${logfile}
  CGO_ENABLED=0 go build -o /app/${component_name} . &>>${logfile}
  status_check
  systemd_service
}

#simple if
status_check() {
  if [ $? -eq 0]; then
    echo -e "\e[32m Success \e[0m"
    else
      echo -e "\e[31m Failure \e[0m"
  fi
}

schema_load() {
  if [ "$schema_load" = "true" ]; then
      if [ "$schema_type" = "mysql"]; then
        echo -e "${header_start} Install mysql client ${header_end}" | tee -a ${logfile}
        dnf install mysql8.4 -y &>>${logfile}
        status_check

        echo -e "${header_start} Load schema,App user and Master data ${header_end}" | tee -a ${logfile}
        #below drop table is to avoid failure for every rerun
        #mysql -h localhost -u root -pRoboShop@1 -e "DROP DATABASE IF EXISTS ${component_name};"
        mysql -h localhost -u root -pRoboShop@1 < db/schema.sql &>>${logfile}
        mysql -h localhost -u root -pRoboShop@1 < db/app-user.sql &>>${logfile}
        mysql -h localhost -u root -pRoboShop@1 ${component_name} < db/master-data.sql &>>${logfile}
        status_check

      fi
  fi
}

