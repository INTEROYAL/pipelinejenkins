pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                // Checkout the repository
                git url: 'https://github.com/INTEROYAL/pipelinejenkins.git', branch: 'main'
            }
        }

        stage('Create S3 Bucket') {
            steps {
                script {
                    def bucketName = 'testttting83898'
                    def bucketExists = sh(script: "aws s3api head-bucket --bucket ${bucketName} --output text 2>&1 || echo 'No'", returnStdout: true).trim()
                    if (bucketExists == 'No') {
                        sh "aws s3api create-bucket --bucket ${bucketName} --region us-east-1"
                    }
                }
            }
        }

     stage('Deploy to S3') {
    steps {
        withAWS(credentials: 'your-aws-credentials-id', region: 'us-east-2') {
            s3Upload(bucket: 'testttting83898', file: 'index7latest.html')
        }
    }
}


    post {
        always {
            // Clean up, or send notifications, etc.
            cleanWs()
        }
    }
}