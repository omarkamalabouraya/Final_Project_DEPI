### Final Java DevOps CI/CD project.

## Description 

This is a simple Java web app that needs to have an automated CI/CD using the DevOps toolset. The Application shall be running as a container on the same VM on port 8080. Test the application by visiting this URL http://localhost:8080/jpetstore.

## The used tools

- Git/Github -> clone the code.
- Maven -> build the code.
- Docker -> dockerize the app
- Jenkins -> CI/CD
- Ansible -> deploy by running a container of the app
- Terraform (Plus) -> to create the EC2 on AWS 
- AWS (plus) -> EC2 machine that shall run the pipeline and host the application

## The requirements

1- CI/CD pipeline that do as following 

CI:
- Clone the source code.
- Build the code using mvnw (already in the repo)
- Test the code using mvnw (already in the repo)
- Dockerize the application and push it to dockerhub

CD:
- Deploy the application by running a container from the image using Ansible.
- Apply the monitoring on the machine using Prometheus. 

2- Create the EC2 instance using terraform instead of using the local VM (Plus)

## The expected delevirable

Github repo containes 
- The src code.
- The Dockerfile
- The Jenkinsfile
- The Ansible Playbook

## Note 

This application build is resulting a .war file not .jar as we saw before. This needs a change in the command that is used to run the application. We will use mvnw as well to run the application as shown below. Here's the command used to run the app:

./mvnw cargo:run -P tomcat90


## Build Docker image:
mvn -N io.takari:maven:wrapper
./mvnw clean package -DskipTests
docker build -t jpetstore .
docker run -p 8080:8080 --name jpetstore_container jpetstore

