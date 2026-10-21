source common.sh
component_name=frontend

echo log file output : ${logfile}
echo -e "${header_start} InStalling nginx ${header_end}"
dnf install -y nginx &>>${logfile}
echo $?

echo -e "${header_start} Copy nginx conf ${header_end}"
cp nginx.conf  /etc/nginx/nginx.conf  &>>${logfile}
echo $?
echo -e "${header_start} Download NodeJS runtime ${header_end}"
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -  &>>${logfile}
echo $?

echo -e "${header_start}InStalling Nodejs ${header_end}"
dnf install -y nodejs  &>>${logfile}
echo $?

echo -e "${header_start} Download frontend code ${header_end}"
curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip  &>>${logfile}
echo $?

echo -e "${header_start} Removing old content ${header_end}"
rm -rf /tmp/frontend  &>>${logfile}
echo $?

echo -e "${header_start} Creating directory for app code ${header_end}"
mkdir -p /tmp/frontend  &>>${logfile}
echo $?

echo -e "${header_start} CD directory for app folder ${header_end}"
cd /tmp/frontend  &>>${logfile}
echo $?
echo -e "${header_start} unarchiving the app code ${header_end}"
unzip /tmp/frontend.zip  &>>${logfile}
echo $?
echo -e "${header_start} Npm install frontend ${header_end}"
npm install  &>>${logfile}
echo $?
echo -e "${header_start} Npm run  build ${header_end}"
npm run build  &>>${logfile}
echo $?
echo -e "${header_start} removing nginx default html content ${header_end}"
rm -rf /usr/share/nginx/html/*  &>>${logfile}
echo $?
cp -r out/* /usr/share/nginx/html/  &>>${logfile}
echo $?

echo -e "\e[35m Starting the nginx"
systemctl restart nginx  &>>${logfile}
echo $?
systemctl enable nginx  &>>${logfile}
echo $?