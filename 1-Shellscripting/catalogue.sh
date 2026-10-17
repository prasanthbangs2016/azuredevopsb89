dnf install -y golang git mysql8.4
go version

curl -L -o /tmp/catalogue.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/catalogue.zip
rm -rf /app
mkdir -p /app
cd /app
unzip /tmp/catalogue.zip
mysql -h localhost -u root -pRoboShop@1 < db/schema.sql
mysql -h localhost -u root -pRoboShop@1 < db/app-user.sql
mysql -h localhost -u root -pRoboShop@1 catalogue < db/master-data.sql