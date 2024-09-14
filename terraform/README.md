### Providers ([provider.tf](provider.tf))
The configuration for the Terraform AWS provider and the backend settings used to manage state files.
- The backend configuration defines where and how Terraform state files are stored. In this setup, an S3 bucket is used for storing the state file, and DynamoDB is used for state locking to prevent concurrent modifications.
- The AWS provider is configured to use the region specified by the aws_region variable.

### Outputs ([output.tf](output.tf))
This Terraform configuration defines an output that provides the DNS name of an Application Load Balancer (ALB).

### Variables ([variables.tf](variables.tf))
This section describes the Terraform variables used in the configurations. These variables define various settings for the infrastructure and applications with the default values.

### VPC ([vpc.tf](vpc.tf))
The configuration for setting up a Virtual Private Cloud (VPC) using the terraform-aws-modules/vpc/aws module. The configuration specifies network settings and attributes for the VPC.

**CIDR Block:** The VPC will use the range 10.0.0.0/16 for its private address space.

**Availability Zones (AZs):** Subnets are created across two AZs. This ensures high availability.

**Subnets:**
Private Subnets: 10.0.1.0/24 and 10.0.2.0/24 for internal services.
Public Subnets: 10.0.101.0/24 and 10.0.102.0/24 for resources that need public internet access (e.g., load balancers).

**DNS:**
enable_dns_hostnames: Enables DNS hostnames for resources in the VPC.
enable_dns_support: Ensures that instances in the VPC can resolve AWS-provided DNS hostnames.

**NAT Gateway:** A single NAT gateway is enabled to allow instances in private subnets to access the internet while remaining hidden from incoming connections.

### Security Groups ([securitygroups.tf](securitygroups.tf))
The configuration for AWS Security Groups used for an Application Load Balancer (ALB) and two applications (App1 and App2). 

**Application Load Balancer(alb_sg):**
Ingress: Allows incoming traffic on http port 80
Egress: Allow all outgoing traffic

**App1 (app1_sg):**
Ingress: Allow incoming traffic from Application Load Balancer on http port 8000
Egress: Allow all outgoing traffic

**App2 (app2_sg):**
Ingress: Allow incoming traffic from App1 on http port 8001
Egress: Allow all outgoing traffic

### IAM ([iam.tf](iam.tf))
This Terraform configuration sets up an IAM role for Amazon ECS tasks, including necessary policies for task execution and secret access.

**ECS Task Execution Role Policy:** IAM policy document that allows ECS tasks to assume the role.

**ECS Task Execution Role:** IAM role for ECS task execution.

**ECS Task IAM Role Policy Attachment:** Attaches the Amazon ECS Task Execution Role policy to the IAM role created.

**ECS Task Secrets Access Policy:** Creates a custom IAM policy that allows the ECS task execution role to access specified secrets in AWS Secrets Manager.


### Application Load Balancer ([alb.tf](alb.tf))
The configuration for setting up an AWS Application Load Balancer (ALB), an ALB Target Group, and an ALB Listener for App1.

**ALB configuration:**
The ALB routes external HTTP requests to the ECS tasks running the App1 microservice.
- Type: Application Load Balancer (HTTP-based routing).
- Subnets: ALB is deployed in public subnets.
- Security Group: Controls access to the ALB.

**Target Group Configuration:**
- Port: Uses HTTP protocol.
- Health Check: Monitors App1 health via /get/send/health.

**Listener:**
- Default Action: Forwards traffic to the App1 target group for load balancing.

### Service Discovery ([servicediscovery.tf](servicediscovery.tf))
This Terraform configuration sets up AWS Service Discovery with private DNS namespaces and services.

**Service Discovery Private DNS Namespace:**
Creates a private DNS namespace for service discovery in the created VPC.

**App1 and App2 Service Discovery:**
- Creates a service discovery entry for app1 in the private DNS namespace.
- Defines DNS records with Time-to-live as 10seconds and type of DNS record as 'A record'.
- Defines the routing policy for DNS queries (MULTIVALUE). The MULTIVALUE routing policy allows DNS queries to return multiple IP addresses, providing basic load balancing.
- Number of failed health checks before the service is considered unhealthy is set to 2.


### ECS ([ecs.tf](ecs.tf))
The Terraform configuration for setting up an ECS (Elastic Container Service) cluster, defining two ECS task definitions for microservices, and deploying these tasks on AWS Fargate. The configuration includes ECS services, network configurations, load balancers, and service discovery for both App1 and App2.

**ECS Cluster:** The aws_ecs_cluster resource creates an ECS cluster for the microservices.

**Task Definitions:** Defines two task definitions (app1 and app2) using Fargate, which are pulled from GitLab container registry. Both services run on isolated AWS VPC subnets with resource limits set for CPU and memory.

**App1 Task Definition:**
- Image: app1 is pulled from the GitLab registry.
- CPU/Memory: Defined using variables.
- Port Mappings: Defined using variables.
- Repository Credentials: Passed credentials configured for gitlab private repository access using Secrets Manager.
- Environment Variables: Configured App2 URL to be obtained via App2 Service Discovery and Private DNS resource configurations.
- Log Configuration: Used AWS CloudWatch log groups and streams.

**App2 Task Definition:**
- Image: app2 is pulled from the GitLab registry.
- CPU/Memory: Defined using variables.
- Port Mappings: Defined using variables.
- Repository Credentials: Passed credentials configured for gitlab private repository access using Secrets Manager.
- Log Configuration: Used AWS CloudWatch log groups and streams.

**App1 ECS Service:**
- Cluster: The ECS cluster where App1 is deployed.
- Task Definition: References the App1 task definition.
- Desired Count: Number of tasks running.
- Load Balancer: Associated with the Application Load Balancer (ALB) for App1.
- Service Discovery: Registered with AWS Cloud Map for internal DNS-based discovery.

**App2 ECS Service**
- Cluster: The ECS cluster where App2 is deployed.
- Task Definition: References the App2 task definition.
- Service Discovery: Registered with AWS Cloud Map for internal DNS-based discovery.


### ECS AutoScaling ([ecs_autoscaling.tf](ecs_autoscaling.tf))
Auto-scaling configuration for two ECS services, App1 and App2, using AWS Application Auto Scaling.The configuration allows ECS tasks to scale based on CPU utilization. 

**Auto Scaling Target for ECS Services**
Specifies the scaling target for the ECS services. Scalable Dimension is `ecs:service:DesiredCount`, means the scaling is based on the desired task count in the ECS service. ECS services are scaled up or down between 1 and 4 tasks.

**Auto Scaling Policy for CPU Utilization**
Defines how the service should scale based on CPU utilization. This configuration uses target tracking, meaning it will scale in or out to maintain a target CPU utilization. Predefined Metric is `ECSServiceAverageCPUUtilization` and target value is 80% CPU utilization.

### Cloud Watch ([cloudwatch.tf](cloudwatch.tf))
The ECS tasks for both App1 and App2 are configured to log their activities to AWS CloudWatch.
- Log Group: Created for App1 and App2 under the /ecs/app1-task and /ecs/app2-task paths, respectively, with logs retained for 1 day.
- Log Stream: Separate log streams are configured for both applications, allowing easy access to task-specific logs in CloudWatch.
- SNS Topic: To publish alerts triggered by the CloudWatch alarms monitoring the ECS services.
- SNS Topic Subscription: This creates a subscription to the SNS topic, sending alerts to the specified email address.
- CloudWatch Metric Alarms: CloudWatch alarms monitor the CPU utilization of app1_service and app2_service. If CPU utilization exceeds 45% for two consecutive periods of 60 seconds, the alarm triggers and sends a notification to the SNS topic.
