pipeline {
    agent any 

    environment {
        AWS_CREDENTIALS = credentials('aws-jenkinscredential')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/INTEROYAL/pipelinejenkins'
            }
        }

        stage('Initialize Terraform') {
            steps {
                dir('terraform') {
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
                        sh 'terraform plan -var="domain_name=terracloudrlm.com"'
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir('terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkinscredential']]) {
                        sh 'terraform apply -auto-approve -var="domain_name=terracloudrlm.com"'
                    }
                }
            }
        }

        stage('Deploy HTML and Photos') {
            steps {
                dir('website') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkinscredential']]) {
                        sh 'aws s3 sync . s3://terracloudrlm.com/ --acl public-read'
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
