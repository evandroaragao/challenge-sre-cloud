#!/bin/bash

#Declaring Vars
APPLICATION_PATH=""
APPLICATION_VERSION=""

echo "Use this script to launch a new application build."
#Ask user if he wants to continue with execution.
read -r -p "Do you want to continue with the execution? [Y/n]" confirmation
if [[ $confirmation =~ ^(y| ) ]] || [[ -z $confirmation ]]; then
    echo "OK, continuing with the execution"
    echo "."
    echo "Please type the complete local path of your main.go file. e.g: /home/ec2-user/main.go.:"
    read -p "Type the file path and press ENTER:" APPLICATION_PATH
    
    #Check if the file exists and take actions
    if [ -f "$APPLICATION_PATH" ]; then
        echo "$APPLICATION_PATH exists, continuing with the script"
        read -p "Please type the new version of the application and press ENTER.:" APPLICATION_VERSION
        if [[ $APPLICATION_VERSION = "" ]]; then
        echo "You need to type the version. Try again"
           else
            echo "OK, building your docker image."
            echo "."
            echo ".."
            sudo rm -f /application/main.go
            sudo cp $APPLICATION_PATH /application/main.go
            cd /application
            sudo docker build -t my-go-app:$APPLICATION_VERSION .
            echo "."
            echo ".."
            echo "Trying to run the new container version"
            sudo docker rm $(docker stop $(docker ps -a -q --filter name=challenge-app --format="{{.ID}}"))
            sudo docker run -d --restart always --name challenge-app -p 8080:8080 my-go-app:$APPLICATION_VERSION
            echo "."
            echo ".."
            echo "Testing application..."
            echo "This is the response:"
            curl http://localhost:8080
            echo ""
        fi
      else
        echo "$APPLICATION_PATH does not exists, check you file and try again"
    fi

fi