pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                // Checkout your repository
                git 'https://github.com/INTEROYAL/pipelinejenkins.git', branch: 'main'
            }
        }
        stage('Create S3 Bucket') {
            steps {
                script {
                    // Check if the bucket exists
                    def bucketExists = sh(script: "aws s3api head-bucket --bucket testttting83898 2>&1 || true", returnStatus: true)
                    
                    if (bucketExists != 0) {
                        // Create the bucket if it doesn't exist
                        sh "aws s3api create-bucket --bucket testttting83898 --region us-east-2 --create-bucket-configuration LocationConstraint=us-east-2"
                    } else {
                        echo "Bucket already exists."
                    }
                }
            }
        }
        stage('Deploy to S3') {
            steps {
                withAWS(region: 'us-east-2', credentials: 'your-aws-credentials-id') {
                    // Upload files to the bucket
                    sh "aws s3 cp /var/jenkins_home/workspace/Projectjenkins2/index7latest.html s3://testttting83898/"
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
