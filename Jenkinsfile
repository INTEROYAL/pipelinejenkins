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
                    // Change to the terraform directory and initialize Terraform
                    dir('terraform') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                script {
                    // Change to the terraform directory and plan the Terraform changes
                    dir('terraform') {
                        sh 'terraform plan -var="domain_name=terracloudrlm.com"'
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {
                    // Change to the terraform directory and apply the Terraform changes
                    dir('terraform') {
                        sh 'terraform apply -auto-approve -var="domain_name=terracloudrlm.com"'
                    }
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
