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
        stage('test') {
            steps {
               sh '''
                    echo "Test stage"
                    if [ -f build/index.html ]; then
                                      echo "index.html found"
                                    else
                                      echo "index.html is missing, failing the build"
                                      exit 1
                                    fi
                    npm run test
                  '''
            }
        }


    }

}
