pipeline {
    agent any

    stages {
        stage('build') {
           agent {
               docker {
                   image 'node:18-alpine'
                   reuseNode true
               }
           }
           steps {
               sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci
                    npm run build

                  '''
           }
        }

        stage("Run Test"){
            parallel{
                stage('test') {
                                    // 让 "test" 阶段也使用相同 Docker 容器
                                    agent {
                                        docker {
                                            image 'node:18-alpine'
                                            reuseNode true
                                        }
                                    }
                                    steps {
                                        sh '''
                                            echo "Test stage"
                                            if [ -f build/index.html ]; then
                                              echo "index.html found"
                                            else
                                              echo "index.html is missing, failing the build"
                                              exit 1
                                            fi
                                            npm test
                                        '''
                                    }
                        }

                stage('E2E') {
                                            // 让 "test" 阶段也使用相同 Docker 容器
                                            agent {
                                                docker {
                                                    image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                                                    reuseNode true
                                                    args '-u root:root'
                                                }
                                            }
                                            steps {
                                                sh '''
                                                    npm install serve
                                                    node_modules/.bin/serve -s build &
                                                    sleep 10
                                                    npx playwright test --reporter=html
                                                '''
                                            }
                        }
            }
        }

        stage('Deploy'){
            agent {
                  docker {
                         image 'node:18-alpine'
                         reuseNode true
                  }
            }
            steps {
                  sh '''
                        npm install netlify-cli
                        node_modules/.bin/netlify --version

                  '''
            }
        }



    }
    post{
        always {
            junit 'jest-results/junit.xml'
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'PlaywrightHTML Report', reportTitles: '', useWrapperFileDirectly: true])
        }
    }

}
