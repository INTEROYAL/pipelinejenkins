pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Initialize Terraform') {
            steps {
                dir('terraform') {
                    // Use withAWS to specify credentials for AWS
                    withAWS(credentials: 'aws-jenkins-credential') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir('terraform') {
                    withAWS(credentials: 'aws-jenkins-credential') {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir('terraform') {
                    withAWS(credentials: 'aws-jenkins-credential') {
                        sh 'terraform apply tfplan'
                    }
                }
            }
        }
    }
}
