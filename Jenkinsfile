pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest' // Use a Docker image with Terraform installed
        }
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone your repository containing Terraform scripts and HTML files
                git branch: 'main', url: 'https://github.com/INTEROYAL/pipelinejenkins'
            }
        }

        stage('Initialize Terraform') {
            steps {
                // Using the existing AWS credentials stored in Jenkins
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkinscredential']]) {
                    sh 'terraform init' // Initialize Terraform
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkinscredential']]) {
                    sh 'terraform plan -var="domain_name=terracloudrlm.com"' // Plan the Terraform deployment
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkinscredential']]) {
                    sh 'terraform apply -auto-approve -var="domain_name=terracloudrlm.com"' // Apply the Terraform configuration
                }
            }
        }

        stage('Deploy HTML and Photos') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkinscredential']]) {
                    sh 'aws s3 sync . s3://terracloudrlm.com/ --acl public-read' // Deploy files to S3
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment succeeded!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
