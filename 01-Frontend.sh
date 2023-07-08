code_dir=${pwd}
log_file=/tmp/roboshop.log

echo -e "\e[34mInstalling Nginx\e[0m"
yum install nginx -y &>>$(log_file)

echo -e "\e[34mEnabling nginx\e[0m"
systemctl enable nginx &>>$(log_file)

echo -e "\e[34mEnabling nginx\e[0m"
systemctl start nginx &>>$(log_file)

echo -e "\e[34mRemoving old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>$(log_file)

echo -e "\e[34mDownloading frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$(log_file)

echo -e "\e[34mExtracting downloaded content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$(log_file)

echo -e "\e[34mCopying Nginx Config for Roboshop\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$(log_file)

echo -e "\e[34mRestart nginx\e[0m"
systemctl restart nginx &>>$(log_file)
