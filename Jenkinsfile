pipeline {
    agent any 

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-jenkinscredential')   // Use your Jenkins credential ID here
        AWS_SECRET_ACCESS_KEY = credentials('aws-jenkinscredential') // Reuse the same credential ID if it includes both
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone your repository containing Terraform scripts
                git branch: 'main', url: 'https://github.com/INTEROYAL/pipelinejenkins'
            }
        }

        stage('Initialize Terraform') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                script {
                    // Plan the Terraform changes
                    sh 'terraform plan -var="domain_name=terracloudrlm.com"'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {
                    // Apply the Terraform changes
                    sh 'terraform apply -auto-approve -var="domain_name=terracloudrlm.com"'
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
