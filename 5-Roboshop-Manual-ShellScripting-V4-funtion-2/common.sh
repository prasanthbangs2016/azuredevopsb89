logfile=/tmp/roboshop.log
header_start="\e[35m >>>>>>"
header_end=">>>>>> \e[0m"

app_pre_reqs() {
  echo -e "${header_start} Copy ${component_name} service file ${header_end}" | tee -a ${logfile}
  cp ${component_name}.service /etc/systemd/system/${component_name}.service &>>${logfile}
  echo $?

  echo -e "${header_start} Create appuser ${header_end}" | tee -a ${logfile}
  useradd -r -s /bin/false appuser &>>${logfile}
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
}

nodejs_app() {
  app_pre_reqs

  echo -e "${header_start} Download Nodejs ${header_end}" | tee -a ${logfile}
  curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &>>${logfile}
  echo $?

  echo -e "${header_start} Install Nodejs ${header_end}" | tee -a ${logfile}
  dnf install -y nodejs &>>${logfile}
  echo $?

  echo -e "${header_start} Download App dependencies ${component_name} code ${header_end}" | tee -a ${logfile}
  npm install --production &>>${logfile}
  systemd_service
}

systemd_service() {

  echo -e "${header_start} Apply permissions to app folder ${header_end}" | tee -a ${logfile}
  chown -R appuser:appuser /app &>>${logfile}
  chmod o-rwx /app -R &>>${logfile}
  echo $?

  echo -e "${header_start} Start ${component_name} ${header_end}" | tee -a ${logfile}
  systemctl daemon-reload &>>${logfile}
  systemctl enable ${component_name} &>>${logfile}
  systemctl start ${component_name} &>>${logfile}
  echo $?
}

golang_app() {
  app_pre_reqs

  echo -e "${header_start} installing Golang GIT ${header_end}" | tee -a ${logfile}
  dnf install -y golang git  &>>${logfile}
  echo $?

  echo -e "${header_start} Compile application code ${header_end}" | tee -a ${logfile}
  go mod tidy &>>${logfile}
  CGO_ENABLED=0 go build -o /app/${component_name} . &>>${logfile}
  echo $?
  systemd_service
}

