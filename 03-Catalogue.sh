source Common.sh

print_head " Configure NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Installing nodejs"
yum install nodejs -y &>>${log_file}

print_head " create Roboshop User "
useradd roboshop &>>${log_file}

print_head " Creating application directory"
mkdir /app &>>${log_file}

print_head "Deleting  old content"
rm -rf /app/* &>>${log_file}

print_head "Downloading setup"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app

print_head "Extracting app Content"
unzip /tmp/catalogue.zip &>>${log_file}

print_head "Installing Nodejs dependencies"
npm install &>>${log_file}

print_head "Copying SystemD Service file"
cp configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}

print_head "Enabling Catalogue"
systemctl enable catalogue &>>${log_file}

print_head "Starting Catalogue"
systemctl start catalogue &>>${log_file}

print_head "Copying Mongodb repo file"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Installing mongo client"
yum install mongodb-org-shell -y &>>${log_file}

print_head "Loading Schema"
mongo --host mongodb-dev.rohandevops.online </app/schema/catalogue.js &>>${log_file}
