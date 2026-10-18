cp rabbitmq_erlang.repo /etc/yum.repos.d/rabbitmq_erlang.repo
dnf install -y erlang rabbitmq-server

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

rabbitmq-plugins enable rabbitmq_management

systemctl restart rabbitmq-server

rabbitmqctl add_user roboshop RoboShop@1
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


systemctl status rabbitmq-server
