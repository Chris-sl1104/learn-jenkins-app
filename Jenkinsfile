pipeline {
    agent any

    environment {
        AWS_S3_BUCKET = 'learn-jenkins-20241221' // 替换为你的 S3 存储桶名称
    }

    stages {

        stage('Upload to AWS S3') {
            agent {
                docker {
                    image 'amazon/aws-cli'
                    args "--entrypoint=''"
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-aws-s3', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                        aws --version
                        echo "Hello S3!" > index.html
                        aws s3 cp index.html s3://$AWS_S3_BUCKET/index.html
                    '''
                }
            }
        }
    }
}
