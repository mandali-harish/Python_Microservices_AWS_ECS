# PythonMicroservicesAWS
A Python-based microservices project deployed on AWS using ECS and Terraform.

## Table of Contents
1. [Introduction](#introduction)
2. [Features](#features)
3. [Infrastructure Overview](#infrastructure-overview)
4. [Deployment Process](#deployment-process)

## Introduction
This repository contains two microservices built using Python FastAPI and deployed on AWS ECS. The infrastructure is managed using Terraform, and Docker is used to containerize the services.
- App1 is a RESTful API that receives a user-provided message, sends this message to App2, and then returns both the original and the processed message.
- App2 reverses the input text and returns both the original and modified messages.

<img src="images/overview.png">

## Features
- **Microservices**: FastAPI-based services (App1 and App2).
- **Docker**: Containerization for efficient deployment.
- **GitLab CI/CD**: To automate the building and pushing of Docker images.
- **AWS**: Deployed in AWS cloud
- **Terraform**: Infrastructure-as-Code for deployment automation.

### Infrastructure Overview
<img src="images/architecture.drawio.png">

The infrastructure is set up using AWS and Terraform. The following services are leveraged:
- **VPC** : AWS Virtual Private Cloud (VPC) enables users to launch AWS resources in a logically isolated virtual network. The VPC has a private and a public subnet in two of the Availability Zones in the Region. An internet gateway to allow communication between the resources in the VPC and the internet. A single NAT gateway to allow instances in private subnet to communicate with internet. 
- **AWS ECS (Elastic Container Service)**: For managing and deploying containers using ECS. ECS Services, Task Definitions, and Auto-Scaling has been defined for both the apps.
- **CloudMap**: CloudMap is a Service Discovery service enables service instances to be registered and discovered within a virtual private cloud. It handles inter-service communication.
- **CloudWatch**: The ECS tasks for both App1 and App2 are configured to log their activities to AWS CloudWatch.
- **Application Load Balancer**:  The Application Load Balancer routes external HTTP requests to the ECS tasks running the App1 microservice.

### Deployment Process
#### Prequisites
- Docker
- AWS CLI: Logged into an AWS Account
- Terraform

#### Walkthrough

#### 1. Creation of Python microservices
1. Created [App1](app1) and [App2](app2) using fastAPI, httpx and uvicorn modules. 
3. Created requirements.txt and Dockerfile files for both microservices.
4. Built docker images.
4. Created docker-compose.yml file to test the microservices.
5. Run in this directory to build and run the apps:
```
docker compose up
```
The `app1` will be running at http://localhost:8000 and the app2 will be at http://localhost:8001

Example usage: 
Requests can be sent to app1 as http://localhost:8000/get/send/hello and the response will be reverse of the original message:
```
{"original":"hello","processed":"olleh"}
```

#### 2. Setting up CI/CD using Gitlab
Created [.gitlab-ci.yml](.gitlab-ci.yml) file and defined the jobs to build docker images for both microservices on commits and merge requests. These docker images will be stored in the gitlab container registry. Which will be later used in the ECS task definitions for creation of containers.

#### 3. Creating AWS Infrastructure in AWS
**Prerequisites**
1. Installed Terraform.
2. Used aws cli to login to the AWS Account.
3. Created an S3 bucket and dynamodb table to store the terraform state file remotely.
4. Defined the [provider.tf](terraform/provider.tf) for AWS and configured to store the terraform state file remotely in S3.
