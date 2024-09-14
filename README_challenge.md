# LiveEO Challenge



## Overview

In this challenge, you are responsible for designing, deploying, and managing two interconnected Python microservices [app1 and app2] on the AWS cloud platform. Your approach should demonstrate best practices in cloud architecture, effective inter-service communication, and operational excellence in a cloud-native application setup.

## Description of Services

### App1
This service functions as a RESTful API that receives a user-provided message, sends this message to App2, and then returns both the original and the processed message. 
#### Dynamic Message Sender:
- Endpoint: `/get/send/{message}`
- Functionality: Receives a message from the user, forwards this message to App2, and returns the original and processed message as received from App2.
- Technology: Python with FastAPI.
- Expected Response: `{ "original": "infra", "processed": "arfni" }` when the endpoint `/get/send/infra` is called.

### App2
Complements App1 by reversing the input text and returning both the original and modified messages, showcasing dynamic data processing in the cloud environment.

- Endpoint: `/api2/send/{message}`
- Functionality: Receives a message, reverses the string, and returns both the original and the reversed message.
- Response Format: Returns a JSON object containing both the original and the reversed message

## AWS Infrastructure and Terraform Integration
The infrastructure for both microservices will be provisioned and managed using Terraform, ensuring that all cloud resources are defined as code for reproducibility, scalability, and version control. 
**We encourage the use of pre-existing terraform modules to make this setup robust and quick or whichever way the candidate feels comfortable with.**

## Version Control with Git
Both app1 and app2 will be managed under Git version control. This includes their source code, Dockerfiles, and any scripts or additional configurations. This practice ensures traceability, collaboration, and integration into the CI/CD pipeline.

## Example Responses

**First Application [App1]**
This is app that give the following response, implemented using Python + FastApi
User Input : `/get/send/infra`
`{ "original": "infra", "processed": "arfni" }`

**Second Application [App2]**
This application utilizes the first app1 and displays a fully reversed message text rendered dynamically.
User Input : `/get/send/{message}`
`{ "original": "infra", "processed": "arfni" }`

## Challenge Objectives

- **Infrastructure as Code (IaC)**: Use Terraform to define and deploy the necessary AWS infrastructure components. Ensure that your Terraform scripts are modular, reusable, and well-documented.

- **Continuous Integration and Continuous Deployment (CI/CD)**: Implement a CI/CD pipeline that automates building of the containerized application

- **Security and Compliance**: Secure the deployment and runtime environment following AWS best practices. 

- **Observability and Control** : Incorporate basic monitoring with AWS and alerting [optional]

- **Documentation and Version Control**: Maintain comprehensive documentation of the deployment process, Terraform configurations, and operational procedures. Ensure all changes are committed to Git, with clear commit messages 

## Deliverables
- [ ] Terraform configurations for the entire AWS infrastructure.
- [ ] CI/CD pipeline configurations and setup details. [Only until docker build]
- [ ] Comprehensive documentation stored in Git repositories along with the application code.


This challenge will assess your ability to utilise AWS services effectively, manage infrastructure as code using Terraform, and implement robust DevOps practices that ensure scalability, security, and operational efficiency in a cloud environment.