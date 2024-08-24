pipeline {
    agent any
    environment{
        CHANNEL_ID= credentials('slack-channel-id')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'bucket', url: 'https://github.com/dhawal-901/major-task-aug-22.git'
            }
        }
        stage("List S3 buckets") {
            steps{
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    script{
                        sh "aws s3 cp ./web-files/ s3://app.test2.dhawal.in.net/ --recursive"
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline Completed'
            slackSend(
                channel: "${CHANNEL_ID}", 
                color: 'good', 
                message: "Your Jenkins Job has been finished Successfully.\n Job: ${env.JOB_NAME}\nBuild Number: #${env.BUILD_NUMBER}.\nBuild_URL:${env.BUILD_URL}",
            )
        }
        failure {
            echo 'Pipeline Failed!'
            slackSend(
                channel: "${CHANNEL_ID}", 
                color: 'danger', 
                message: "Your Jenkins Pipeline has failed.\n Job: ${env.JOB_NAME}\nBuild Number: #${env.BUILD_NUMBER}.\nBuild_URL:${env.BUILD_URL}\n Please check immediately",
            )
        }
    }
}