source common.sh

if [ -z "$1" ]; then
  echo Password input Missing
  exit
fi

MYSQL_ROOT_PASSWORD=$1

echo -e "${color} Disable mysql default version  \e[0m"
dnf module disable mysql -y &>>$log_file
status_check

echo -e "${color} copy mysql repo file \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
status_check

echo -e "${color} install mysql server \e[0m"
dnf install mysql-community-server -y &>>$log_file
status_check

echo -e "${color} start mysql server \e[0m"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
status_check

echo -e "${color} set mysql passward \e[0m"
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$log_file
status_check


