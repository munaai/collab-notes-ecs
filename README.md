# Containerised Real-Time Collaborative Notes on ECS

A collaborative, real-time note editor where multiple users can edit and view simultaneously.
Updates are synchronised instantly across all clients, ensuring a smooth collaboration experience.

This setup automates the deployment of the application on **AWS ECS Fargate**, removing the need for manual resource provisioning through the AWS Console. By using **Terraform** and **GitHub Actions**, the entire infrastructure and deployment process is **repeatable, consistent, and efficient** — reducing human error and saving time across development and operations.


##  Architecture diagram
<p align="center">
  <img src="images/arcitechture-diagram.gif" alt="architechtural diagram" style="width:700px"/>
</p>

##  Features
- Fully automated infrastructure using **Terraform** (with terraform workspaces)  
- Docker container pushed to Amazon ECR
- ECS Fargate service behind an ALB with HTTPS
- **AWS WAF** protection for enhanced security  
- Security scanning with **Trivy** and **Checkov** 
- SSL certificate issued via ACM and validated through Route 53
- **GitHub Actions workflows** for:  
  - Docker image build & push  
  - Terraform plan, apply, and destroy  


## Project Structure
<pre>
./
├── app/
│   └── Dockerfile
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── modules/
│       ├── alb/
│       ├── ecs_fargate/
│       ├── iam_roles/
│       ├── route53/
│       ├── security_groups/
│       └── vpc/
└── .github/
    └── workflows/
        ├── apply.yml
        ├── destroy.yml
        ├── docker.yml
        └── plan.yml

</pre>

## Local App Setup 💻
### Option 1: Run Locally Without Docker
<pre>
cd web
yarn install --frozen-lockfile
yarn dev   # http://localhost:5173
cd ..
go mod download
go run ./bin/memos  
Then visit: http://localhost:5173  — It will connect to http://localhost:8081 (backend).
</pre>  
### Option 2: Run Using Docker
<pre>
docker build -t collab-notes .
docker run -p 8081:8081 collab-notes
Then visit: http://localhost:8081 
</pre>
## Deployment Workflow
### Docker Build and Push
- Builds the Docker image
- Performs a security scan using Trivy
- Pushes the image to Amazon ECR

### Terraform Plan and Apply
- Runs after a successful Docker build or when manually triggered.
- Sets up AWS credentials and downloads terraform.tfvars from S3.
- Runs Terraform formatting check, linter, plan, and apply.
- Automatically provisions or updates infrastructure on AWS.

### Terraform Destroy
- Destroys all infrastructure managed by Terraform when no longer required

## Here is a demonstration

### Domain page
<!-- <p align="center">
  <img src="images/Front-end.png" alt="architechtural diagram" style="width:800px"/>
</p> -->

### SSL certificate
<!-- <p align="center">
  <img src="images/ssl-certificate.png" alt="architechtural diagram" style="width:800px"/>
</p> -->

### Docker Build and Push to ECR
<!-- <p align="center">
  <img src="images/build-image.png" alt="architechtural diagram" style="width:800px"/>
</p> -->

### Terraform Deploy
<!-- <p align="center">
  <img src="images/planandapply.png" alt="architechtural diagram" style="width:800px"/>
</p> -->

### Teraform Destroy
<!-- <p align="center">
  <img src="images/terraform-destroy.png" alt="architechtural diagram" style="width:800px"/>
</p> -->