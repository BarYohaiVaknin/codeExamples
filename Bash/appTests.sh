#!/bin/bash

##############################################
#                  Variables
##############################################
testType=$1
taskName="testName"
updatedURL="www.myweb.com"
instructionsURL="www.google.com"
getAPI='http://app/'
postAPI='http://app/createTask'
putAPI="http://app/updateTask/${taskName}/${updatedURL}"
deleteAPI="http://app/deleteTask/${taskName}"

##############################################
#                  Unit Test
##############################################
if [[ $testType =~ 'ut' ]];then
    echo 'Starting Unit Testing...'
    testResult=$(docker logs app 2>&1 | grep "Running" | wc -l)
    if [[ $testResult -eq '3' ]]; then
        echo "Unit Testing Passed Successfully!"
    else
        echo "Error Accourd While Testing Unit"
        exit 1
    fi

##############################################
#                  E2E Tests
##############################################
elif [[ $testType =~ 'e2e' ]];then
    echo '########### Starting E2E Testing ###########'
    echo '########### Testing GET Method ###########'
    sleep 3
    statusCode=$(curl --write-out '%{http_code}' --silent --output /dev/null -X GET $getAPI)
    if [[ $statusCode -eq 200 ]]; then
        echo "########### GET Method Passed Successfully! ###########"
    else
        echo "########### Error Accourd While Using GET Method ###########"
        exit 1
    fi
    
    echo '########### Testing POST Method ###########'
    sleep 3
    statusCode=$(curl --write-out '%{http_code}' --silent --output /dev/null -d "taskName=${taskName}&instructionsURL=${instructionsURL}" -H "Content-Type: application/x-www-form-urlencoded" -X POST $postAPI)
    if [[ $statusCode -eq 200 ]]; then
        echo "########### POST Method Passed Successfully! ###########"
    else
        echo "########### Error Accourd While Using POST Method ###########"
        exit 1
    fi

    echo '########### Testing PUT Method ###########'
    sleep 3
    statusCode=$(curl --write-out '%{http_code}' --silent --output /dev/null -X PUT "$putAPI")
    if [[ $statusCode -eq 200 ]]; then
        echo "########### PUT Method Passed Successfully! ###########"
    else
        echo "########### Error Accourd While Using PUT Method ###########"
        exit 1
    fi
    
    echo '########### Testing DELETE Method ###########'
    sleep 3
    statusCode=$(curl --write-out '%{http_code}' --silent --output /dev/null -X DELETE "$deleteAPI")
    if [[ $statusCode -eq 200 ]]; then
        echo "########### DELETE Method Passed Successfully! ###########"
    else
        echo "########### Error Accourd While Using PUT Method ###########"
        exit 1
    fi
else
    echo 'No Such Test.'
    exit 1
fi