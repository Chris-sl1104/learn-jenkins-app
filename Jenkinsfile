pipeline {
    agent any

    environment {
        AWS_S3_BUCKET = 'learn-jenkins-20241221' // 替换为你的 S3 存储桶名称
        REACT_APP_VERSION = "1.0.$BUILD_ID"
        AWS_DEFAULT_REGION = 'ap-southeast-2'
        AWS_ECS_CLUSTER = 'LearnJenkinsApp-Cluster-Prod'
        AWS_ECS_SERVICE = 'LearnJenkinsApp-Service-Prod'
        AWS_ECS_TD = 'LearnJenkinsApp-TaskDefinition-Prod'
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

        stage('Build Docker image') {
            steps {
                sh '''
                    docker build -t myjenkinsapp .
                '''
            }
        }

        stage('Deploy to AWS') {
            agent {
                docker {
                    image 'amazon/aws-cli'
                    reuseNode true
                    args "-u root --entrypoint=''"
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-aws-s3', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                        aws --version
                        yum install jq -y
                        LATEST_TD_REVISION=$(aws ecs register-task-definition --cli-input-json file://aws/task-definition-prod.json | jq '.taskDefinition.revision')
                        aws ecs update-service --cluster AWS_ECS_CLUSTER --service AWS_ECS_SERVICE --task-definition AWS_ECS_TD:$LATEST_TD_REVISION
                        aws ecs wait services-stable --cluster AWS_ECS_CLUSTER --services AWS_ECS_SERVICE
                    '''
                }
            }
        }


    }
}
