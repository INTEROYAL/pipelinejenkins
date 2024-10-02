pipeline {
    agent any 

    environment {
        AWS_CREDENTIALS = credentials('aws-jenkinscredential') // Using the stored credentials
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone your repository containing Terraform scripts and HTML files
                git 'https://github.com/INTEROYAL/pipelinejenkins'
            }
        }

        stage('Initialize Terraform') {
            steps {
                // Change directory to where your Terraform scripts are located
                dir('terraform') {
                    // Set AWS environment variables for credentials
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkinscredential']]) {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir('terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkinscredential']]) {
                        // Plan the Terraform changes, passing the domain name
                        sh 'terraform plan -var="domain_name=terracloudrlm.com"'
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir('terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkinscredential']]) {
                        // Apply the Terraform changes
                        sh 'terraform apply -auto-approve -var="domain_name=terracloudrlm.com"'
                    }
                }
            }
        }

        stage('Deploy HTML and Photos') {
            steps {
                dir('website') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkinscredential']]) {
                        // Copy HTML files and photos to the S3 bucket
                        sh '''
                        aws s3 sync . s3://terracloudrlm.com/ --acl public-read
                        '''
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
