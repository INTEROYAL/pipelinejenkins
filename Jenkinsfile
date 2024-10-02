

pipeline {
    agent any 

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
                    terraform init()
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                script {
                    // Plan the Terraform changes
                    terraform plan("-var", "domain_name=terracloudrlm.com")
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {
                    // Apply the Terraform changes
                    terraform apply("-auto-approve", "-var", "domain_name=terracloudrlm.com")
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
