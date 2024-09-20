pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/INTEROYAL/pipelinejenkins.git', branch: 'main'
            }
        }
        stage('Create S3 Bucket') {
            steps {
                script {
                    def bucketExists = sh(script: "aws s3api head-bucket --bucket testttting83898 2>&1 || true", returnStatus: true)
                    
                    if (bucketExists != 0) {
                        sh "aws s3api create-bucket --bucket testttting83898 --region us-east-2 --create-bucket-configuration LocationConstraint=us-east-2"
                    } else {
                        echo "Bucket already exists."
                    }
                }
            }
        }
        stage('Deploy to S3') {
            steps {
                withAWS(credentials: 'your-aws-credentials-id', region: 'us-east-2') {
                    sh "aws s3 cp /var/jenkins_home/workspace/pipelineaws1/index7latest.html s3://testttting83898/"
                }
            }
        }
        stage('Clean Up') {
            steps {
                cleanWs()
            }
        }
    }
    post {
        failure {
            echo 'Pipeline failed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
    }
}
