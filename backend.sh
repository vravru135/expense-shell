source common.sh

if [ -z "$1" ]; then
  echo Password input Missing
  exit
fi

MYSQL_ROOT_PASSWORD=$1

echo -e "${color} Disable Nodejs Default Version \e[0m"
dnf module disable nodejs -y &>>$log_file
status_check

echo -e "${color} enable nodejs 18 version  \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
status_check

echo -e "${color} Install nodejs \e[0m"
dnf install nodejs -y &>>$log_file
status_check

echo -e "${color} Copy Backend Service File \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
status_check

id expense &>>$log_file
if [ $? -ne 0 ]; then
echo -e "${color} Add Application user \e[0m"
useradd expense &>>$log_file
status_check
fi

if [ ! -d /app ]; then
echo -e "${color} Create Application Directory \e[0m"
mkdir /app &>>$log_file
status_check
fi

echo -e "${color} Delete Old Application Content \e[0m"
rm -rf /app/* &>>$log_file
status_check

echo -e "${color} Download Application Content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
status_check

echo -e "${color} Extract Application Content \e[0m"
cd /app &>>$log_file
unzip /tmp/backend.zip &>>$log_file
status_check

echo -e "${color} Download Nodejs Dependencies \e[0m"
npm install &>>$log_file
status_check

echo -e "${color} Install MySQL Client to Load Schema \e[0m"
dnf install mysql -y &>>$log_file
status_check

echo -e "${color} Load Schema \e[0m"
mysql -h mysql-dev.vravru135.online -uroot -p${MYSQL_ROOT_PASSWORD} < /app/schema/backend.sql &>>$log_file
status_check

echo -e "${color} Starting Backend Service \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
status_check

















