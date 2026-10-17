dnf install -y nginx
systemctl enable nginx
systemctl start nginx

curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
dnf install -y nodejs


curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/frontend.zip
mkdir -p /tmp/frontend
cd /tmp/frontend
cp nginx.conf  /etc/nginx/nginx.conf

unzip /tmp/frontend.zip
npm install
npm run build
rm -rf /usr/share/nginx/html/*
cp -r out/* /usr/share/nginx/html/

cp nginx.conf  /etc/nginx/nginx.conf

systemctl restart nginx
systemctl enable nginx