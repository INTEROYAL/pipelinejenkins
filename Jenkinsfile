pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

       
        stage('Destroy Terraform Resources') {
            steps {
                script {
                    dir('terraform') {  // Navigate to your terraform directory
                        withAWS(credentials: 'aws-credentials') { // Replace with your actual AWS credentials
                            sh 'terraform init'  // Initialize Terraform
                            sh 'terraform destroy -auto-approve'  // Destroy resources without prompting for confirmation
                        }
                    }
                }
            }
        }
        
        stage('Refresh Terraform State') {
            steps {
                script {
                    dir('terraform') {  // Navigate to your terraform directory
                        withAWS(credentials: 'aws-credentials') { // Replace with your actual AWS credentials
                            sh 'terraform init'  // Reinitialize Terraform (if necessary)
                            sh 'terraform refresh'  // Refresh the state to match real resources
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            // Actions to perform after pipeline execution, like cleanup or notifications
            echo 'Pipeline completed.'
        }
    }
}