pipeline {
    agent any

    environment {
        AWS_S3_BUCKET = 'learn-jenkins-20241221' // 替换为你的 S3 存储桶名称
    }

    stages {

        stage('Build') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }
                    steps {
                        sh '''
                            ls -a
                            node --version
                            npm --version
                            npm ci
                            npm run build
                            ls -la
                        '''
                    }
                }

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
                        aws s3 sync build s3://$AWS_S3_BUCKET
                    '''
                }
            }
        }
    }
}
