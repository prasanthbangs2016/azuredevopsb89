cp mongodb-org-7.0.repo /etc/yum.repos.d/mongodb-org-7.0.repo

dnf install -y mongodb-org

sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

systemctl enable mongod

systemctl start mongod