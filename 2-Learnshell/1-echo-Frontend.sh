echo -e "\e[35m InStalling nginx \e[0m"
dnf install -y nginx


echo -e "\e[35m Copy nginx conf \e[0m"
cp nginx.conf  /etc/nginx/nginx.conf

echo -e "\e[35m Download NodeJS runtime \e[0m"
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -

echo -e "\e[35m InStalling Nodejs \e[0m"
dnf install -y nodejs

echo -e "\e[35m Download frontend code \e[0m"
curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/frontend.zip

echo -e "\e[35m Removing old content \e[0m"
rm -rf /tmp/frontend

echo -e "\e[35m Creating directory for app code \e[0m"
mkdir -p /tmp/frontend

echo -e "\e[35m CD directory for app folder \e[0m"
cd /tmp/frontend

echo -e "\e[35m unarchiving the app code \e[0m"
unzip /tmp/frontend.zip

echo -e "\e[35m Npm install frontend \e[0m"
npm install

echo -e "\e[35m Npm run  build \e[0m"
npm run build

echo -e "\e[35m removing nginx default html content \e[0m"
rm -rf /usr/share/nginx/html/*
cp -r out/* /usr/share/nginx/html/


echo -e "\e[35m Starting the nginx"
systemctl restart nginx
systemctl enable nginx