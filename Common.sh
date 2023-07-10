code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[35m$1\e[0m"
}
status_check() {
  if [ $1 -eq 0 ]; then
    echo Success
  else
    echo Failure
    exit 1
  fi
}

NODEJS() {
  print_head " Configure NodeJS Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?

  print_head "Installing nodejs"
  yum install nodejs -y &>>${log_file}
  status_check $?

  print_head " create Roboshop User"
  id roboshop &>>${log_file}
  if [ $? -ne 0 ]; then
   useradd roboshop &>>${log_file}
  fi
  status_check $?

  print_head " Creating application directory"
  if [ ! -d /app ]; then
    mkdir /app &>>${log_file}
  fi
  status_check $?

  print_head "Deleting  old content"
  rm -rf /app/* &>>${log_file}
  status_check $?

  print_head "Downloading setup"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  status_check $?
  cd /app

  print_head "Extracting app Content"
  unzip /tmp/${component}.zip &>>${log_file}
  status_check $?

  print_head "Installing Nodejs dependencies"
  npm install &>>${log_file}
  status_check $?

  print_head "Copying SystemD Service file"
  cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  status_check $?

  print_head "Reload SystemD"
  systemctl daemon-reload &>>${log_file}
  status_check $?

  print_head "Enabling Catalogue"
  systemctl enable ${component} &>>${log_file}
  status_check $?

  print_head "Starting Catalogue"
  systemctl start ${component} &>>${log_file}
  status_check $?

  print_head "Copying Mongodb repo file"
  cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
  status_check $?

    print_head "Installing mongo client"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    print_head "Loading Schema"
    mongo --host mongodb-dev.rohandevops.online </app/schema/${component}.js &>>${log_file}
    status_check $?
}