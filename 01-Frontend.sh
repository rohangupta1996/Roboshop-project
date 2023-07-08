code_dir=${pwd}
echo -e "\e[34mInstalling Nginx\e[0m"
yum install nginx -y

echo -e "\e[34mEnabling nginx\e[0m"
systemctl enable nginx

echo -e "\e[34mEnabling nginx\e[0m"
systemctl start nginx

echo -e "\e[34mRemoving old content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[34mDownloading frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[34mExtracting downloaded content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[34mCopying Nginx Config for Roboshop\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[34mRestart nginx\e[0m"
systemctl restart nginx
