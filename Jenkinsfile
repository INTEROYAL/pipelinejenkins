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
                        // Save the plan to a file
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {
                    // Change to the terraform directory and apply the Terraform changes
                    dir('terraform') {
                        // Apply the saved plan
                        sh 'terraform apply -auto-approve tfplan'
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
            // Capture logs for further debugging
            dir('terraform') {
                sh 'terraform apply -auto-approve tfplan || true'  // Attempt to output any logs even if the apply fails
                echo 'Check Terraform logs for more details.'
            }
        }
    }
}
