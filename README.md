# Welcome To Bar Yohai Vaknin's Repository

  

# This reposotiroy created to give you an insight to code exmaples in different technologies.

  

# ArgoCD:

The "app" folder includes an umbrella chart of python app and it's DB (MongoDB) as a dependency.<br  />

The "a-o-a.yaml" is an helm chart which using the app of apps pattern to deploy prometheus and grafana as monitoring and alerting solution, and nginx ingress controller as an LB for EKS cluster.<br  />

The "a-o-a" folder including all of the helm charts below:<br  />

Application <br  />

>Python app and MongoDB<br  />

Ingress Control:<br  />

> Nginx as LB<br  />

Prometheus :<br  />

> Monitoring purposes.

Grafana :<br  />

> Refelcting and Alerting purposes.

  

# Bash:

There are Two scripts on this folder:<br  />
* "appTests.sh" - Including two type of tests:<br  />
    >Unit test - to check wheter if the python app is running or not.
    >E2E tests -  testing the app with different HTTP methods. 

* "argoInit.sh" - Including Three actions:<br  />
    >Updating kubeconfig with the new cluster.
    >Setting the git repository on ArgoCD for git-ops purposes and deploying the a-o-a.yaml
    >Updating the DNS resolver with the ip of the new LB

  

# Docker:

Contains two files:<br  />

>"dockerfile" which dockerize the python app, using python:3.8.2-slim-buster as a base image.
>"docker-compose" which used as a part of the CI pipeline to run an testing environment (DB & App) for testing purposes.

  

# IaC-TF:

On this folder there are setup which using an existing VPC on AWS and deploying EKS cluster.<br  />

The resources will be provisioned are:<br  />

* EKS Cluster:<br  />
>>1 Node Using t3.xlarge instance type<br  />

* ArgoCD<br  />

* ebsDriver<br  />

  

# Jenkins:

On this folder you can find a Jenkinsfile with 8 Stages + Post Stage as mentioned below:<br  />

1. Clone Stage<br  />

>Cloning the source files from two repositories - the application repository and ArgoCD's SCM (for the Deploy stage).

2. Tag Calculation Stage<br  />

>In case of a push from the main branch, I've implemented an semantic versioning stage which tagging images that built & tested successfully <br  />
>This stage is calculating the next tag.

3. Build Stage<br  />

>Building the dockerfile.

4. Unit Test Stage<br  />

>Using "docker compose up" to run the testing env. and getting the docker logs to make sure the application is running.

5. E2E Test Stage<br  />

* Running E2E tests which includes testing for four HTTP methods:<br  />

> >GET<br  />

>> POST<br  />

>> PUT<br  />

> >DELETE<br  />

>if the status code '200' will return as a result, the tests will pass successfully.

6. Tagging Stage<br  />

> Tagging with docker & git the image with the tag which calculated on stage 2.

7. Publish Stage<br  />

>Publishing the image to AWS container registery service (ECR).

8. Deploy Stage<br  />

>Changing the values of ArgoCD's SCM to the updated image version, so ArgoCD will pull the change and update the deployment.

9. Post Stage<br  />

>Informing the user which pushed the changes to git with the result of the pipeline.

  

# pythonApp:

On this folder you will find a python app which providing an admin panel for teachers, it's html templates and requirements.txt.<br  />

The app using four HTTP methods (GET, POST, PUT and DELETE) to get, change or delete data from it's database.<br  />
