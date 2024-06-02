pipeline {
    agent any

    stages {
        stage('Build and Push') {
            steps {
                echo 'Building and pushing'
                sh 'docker ps -a'
                sh 'docker build -t ttl.sh/docker-k8s-node-frank .'
                sh 'docker push ttl.sh/docker-k8s-node-frank'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to target'
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey2',
                                                   keyFileVariable: 'mykey',
                                                   usernameVariable: 'myuser')]) {
                    sh "ssh vagrant@192.168.105.3 -i ${mykey} \"docker ps -a\""

                    script {
                        // Stop and remove containers
                        sh "ssh vagrant@192.168.105.3 -i ${mykey} \"docker stop myapp || true && docker rm myapp || true\""
                    }
                    
                    sh "ssh vagrant@192.168.105.3 -i ${mykey} \"docker run -d -p 5555:5555 --name myapp ttl.sh/docker-k8s-node-frank\""
                }
            }
        }
    }
}