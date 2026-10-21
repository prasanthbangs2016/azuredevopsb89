logfile=/tmp/roboshop.log
header_start="\e[35m >>>>>>"
header_end=">>>>>> \e[0m"

app_pre_reqs() {

    echo -e "${header_start} Creating application user ${header_end}"
    useradd -r -s /bin/false appuser
    echo $?

    echo -e "${header_start} copy ${component_name} service file ${header_end}"
    cp ${component_name}.service /etc/systemd/system/${component_name}.service
    echo $?

    echo -e "${header_start} Download ${component_name} code ${header_end}"
    curl -L -o /tmp/catalogue.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip &>>/${logfile}
    echo $?

    echo -e "${header_start} Creating directory for ${component_name} ${header_end}"
    rm -rf /app &>>${logfile}
    mkdir -p /app &>>${logfile}
    cd /app &>>${logfile}
    echo $?

    echo -e "${header_start} ${component_name} code Extraction ${header_end}"
    unzip /tmp/catalogue.zip &>>${logfile}

    rm -rf /app &>>${logfile}
    mkdir -p /app &>>${logfile}
    echo $?
}


systemd_service() {
        echo -e "${header_start} Apply permission for application folder ${header_end}"
        chown -R appuser:appuser /app
        chmod o-rwx /app -R
        echo $?

        echo -e "${header_start} Start Service ${header_end}"
        systemctl daemon-reload
        systemctl enable catalogue
        systemctl start
        $?


}



nodejs_app() {

    app_pre_reqs


    echo -e "${header_start} Download NodeJS runtime ${header_end}"
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -  &>>${logfile}
    echo $?

    echo -e "${header_start}InStalling Nodejs ${header_end}"
    dnf install -y nodejs  &>>${logfile}
    echo $?

    systemd_service
}

go_lang() {

    app_pre_reqs

    echo -e "${header_start} install golang mysql git ${header_end}"
    dnf install -y golang git mysql8.4
    go mod tidy
    CGO_ENABLED=0 go build -o /app/catalogue .
    $?
    systemd_service
}