#!/bin/bash

##############################################
#                  Variables
##############################################
region='eu-west-1'
clusterName='my-eks-cluster'
myDNSCreds=$(aws secretsmanager get-secret-value --region us-west-1 --secret-id mydns/creds)
userName=$(echo $myDNSCreds | jq -r '.SecretString | fromjson | .username')
password=$(echo $myDNSCreds | jq -r '.SecretString | fromjson | .password')
noipHost='my.dns.com'
newIP=$(dig $(k get svc | grep "amazon" | awk -F ' ' '{print $4}') | grep "60 IN" | awk -F ' ' '{print $5}' | head -n1)

echo "Updating kubeconfig..."
aws eks --region $region update-kubeconfig --name $clusterName
echo "Applying a-o-a.yaml on argo..."
kubectl apply -f ../argoGitConf.yaml -f ../portfolio-gitops/a-o-a.yaml
echo "Updating new elb's IP on NO-IP..."
curl -u $userName:$password "http://dynupdate.no-ip.com/nic/update?hostname=$noipHost&myip=$newIP"