pipeline {
    agent any
    stages {
        stage('Setting up OWASP ZAP docker container') {
            steps {
                script {
                    echo "Pulling up last OWASP ZAP container --> Start"
                    sh 'docker pull owasp/zap2docker-stable'
                    echo "Pulling up last VMS container --> End"
                    echo "Starting container --> Start"
                    sh """
                    docker run -dt --name owasp \
                    owasp/zap2docker-stable \
                    /bin/bash
                    """
                }
            }
        }
        stage('Prepare wrk directory') {
            steps {
                script {
                    sh """
                    docker exec owasp \
                    mkdir /zap/wrk
                    """
                }
            }
        }
        stage('Scanning target on owasp container') {
            steps {
                script {
                    target = "http://10.19.1.17:8081/webapp"
                    try{
                        sh """
                        docker exec owasp \
                        zap-baseline-scan.py \
                        -t $target \
                        -x report.xml
                        -I
                        """
                    }
                    catch (err) {
                        echo err.getMessage()
                        }
                }
            }
        }
        stage('Copy Report to Workspace'){
            steps {
                script {
                    sh '''
                    docker cp owasp:/zap/wrk/report.xml ${WORKSPACE}/report.xml
                    '''
                }
            }
        }
    }
    post{
        always {
            echo "Removing container"
            sh '''
            docker stop owasp
            docker rm owasp
            '''
        }
    }
}
