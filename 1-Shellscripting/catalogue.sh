dnf install -y golang git mysql8.4
go version

curl -L -o /tmp/catalogue.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/catalogue.zip
rm -rf /app
mkdir -p /app
cd /app
unzip /tmp/catalogue.zip

#below drop table is to avoid failure for every rerun
mysql -h localhost -u root -pRoboShop@1 -e "DROP DATABASE IF EXISTS catalogue;"
mysql -h localhost -u root -pRoboShop@1 < db/schema.sql
mysql -h localhost -u root -pRoboShop@1 < db/app-user.sql
mysql -h localhost -u root -pRoboShop@1 catalogue < db/master-data.sql


# Create the app user only if it does not exist
#useradd -r -s /bin/false appuser
if ! id appuser >/dev/null 2>&1; then
  useradd -r -s /bin/false appuser
fi
cd /app
go mod tidy
CGO_ENABLED=0 go build -o /app/catalogue .
chown -R appuser:appuser /app
chmod o-rwx /app -R

cp catalogue.service /etc/systemd/system/catalogue.service

systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

systemctl status catalogue