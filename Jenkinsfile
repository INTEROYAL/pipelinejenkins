// pipeline {
//     agent any 

//     environment {
//         AWS_ACCESS_KEY_ID = credentials('aws-jenkinscredential')   // Use your Jenkins credential ID here
//         AWS_SECRET_ACCESS_KEY = credentials('aws-jenkinscredential') // Reuse the same credential ID if it includes both
//     }

//     stages {
//         stage('Clone Repository') {
//             steps {
//                 // Clone your repository containing Terraform scripts
//                 git branch: 'main', url: 'https://github.com/INTEROYAL/pipelinejenkins'
//             }
//         }

//         stage('Initialize Terraform') {
//             steps {
//                 script {
//                     // Change to the terraform directory and initialize Terraform
//                     dir('terraform') {
//                         sh 'terraform init'
//                     }
//                 }
//             }
//         }

//         stage('Plan Terraform') {
//             steps {
//                 script {
//                     // Change to the terraform directory and plan the Terraform changes
//                     dir('terraform') {
//                         // Save the plan to a file
//                         sh 'terraform plan -out=tfplan'
//                     }
//                 }
//             }
//         }

//         stage('Apply Terraform') {
//             steps {
//                 script {
//                     // Change to the terraform directory and apply the Terraform changes
//                     dir('terraform') {
//                         // Apply the saved plan
//                         sh 'terraform apply -auto-approve tfplan'
//                     }
//                 }
//             }
//         }
//     }

//     post {
//         success {
//             echo 'Deployment succeeded!'
//         }
//         failure {
//             echo 'Deployment failed!'
//             // Capture logs for further debugging
//             dir('terraform') {
//                 sh 'terraform apply -auto-approve tfplan || true'  // Attempt to output any logs even if the apply fails
//                 echo 'Check Terraform logs for more details.'
//             }
//         }
//     }
// }




// ____________________________________________________________________________________________________________________

//Finally Working Complete ( remember to add Cloudfront distribution ID script to Output.tf)

// output "cloudfront_distribution_id" {
//   value = aws_cloudfront_distribution.s3_distribution.id
//   description = "The ID of the CloudFront distribution."
// }
// ____________________________________________________________________________________________________________________
// pipeline {
//     agent any
//     environment {
//         AWS_DEFAULT_REGION = 'us-east-2' // Set your AWS region
//     }
//     stages {
//         stage('Checkout Code') {
//             steps {
//                 git branch: 'main', url: 'https://github.com/INTEROYAL/pipelinejenkins.git'
//             }
//         }
//         stage('Initialize AWS Credentials') {
//             steps {
//                 withAWS(credentials: 'aws-jenkinscredential') {
//                     // No additional steps required here
//                 }
//             }
//         }
//         stage('Get Commit Message') {
//             steps {
//                 script {
//                     def commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
//                     echo "Latest Commit Message: ${commitMessage}"

//                     if (commitMessage.contains('bucket delete')) {
//                         echo "Detected 'bucket delete' in commit message."
//                         env.DESTROY = "true"
//                     } else {
//                         env.DESTROY = "false"
//                     }
//                 }
//             }
//         }
//         stage('Initialize Terraform') {
//             when {
//                 expression { return env.DESTROY == "false" }
//             }
//             steps {
//                 sh 'terraform init'
//             }
//         }
//         stage('Plan Terraform Changes') {
//             when {
//                 expression { return env.DESTROY == "false" }
//             }
//             steps {
//                 sh 'terraform plan -out=tfplan'
//             }
//         }
//         stage('Apply Terraform Changes') {
//             when {
//                 expression { return env.DESTROY == "false" }
//             }
//             steps {
//                 script {
//                     try {
//                         sh 'terraform apply -auto-approve tfplan'

//                         // Fetch CloudFront distribution ID from Terraform output
//                         env.S3_BUCKET_NAME = 'cloudfroterrasv1616' // Static bucket name
//                         env.CLOUDFRONT_DISTRIBUTION_ID = sh(script: 'terraform output -raw cloudfront_distribution_id', returnStdout: true).trim()

//                         echo "S3 Bucket: ${env.S3_BUCKET_NAME}"
//                         echo "CloudFront Distribution ID: ${env.CLOUDFRONT_DISTRIBUTION_ID}"
//                     } catch (Exception e) {
//                         echo "Terraform apply failed: ${e}"
//                     }
//                 }
//             }
//         }
//         stage('Invalidate CloudFront Cache') {
//             when {
//                 expression { return env.DESTROY == "false" && env.CLOUDFRONT_DISTRIBUTION_ID != null && env.CLOUDFRONT_DISTRIBUTION_ID != '' }
//             }
//             steps {
//                 script {
//                     echo "Invalidating CloudFront Cache..."
//                     sh """
//                         aws cloudfront create-invalidation --distribution-id ${env.CLOUDFRONT_DISTRIBUTION_ID} --paths "/*"
//                     """
//                 }
//             }
//         }
//         stage('Destroy Resources') {
//             when {
//                 expression { return env.DESTROY == "true" }
//             }
//             steps {
//                 sh 'terraform destroy -auto-approve'
//             }
//         }
//     }
//     post {
//         always {
//             echo "Pipeline completed."
//         }
//     }
// }
