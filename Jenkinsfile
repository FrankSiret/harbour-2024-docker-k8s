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

        stage('Deploy to target') {
            steps {
                echo 'Deploying to target'
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey',
                                                   keyFileVariable: 'mykey',
                                                   usernameVariable: 'myuser')]) {
                    sh "ssh ${myuser}@192.168.105.3 -i ${mykey} \"docker ps -a\""

                    script {
                        // Stop and remove containers
                        sh "ssh vagrant@192.168.105.3 -i ${mykey} \"docker stop myapp || true && docker rm myapp || true\""
                    }
                    
                    sh "ssh vagrant@192.168.105.3 -i ${mykey} \"docker run -d -p 5555:5555 --name myapp ttl.sh/docker-k8s-node-frank\""
                }
            }
        }

        stage('Deploy to k8s') {
            steps {
                echo 'Deploying to k8s'
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey',
                                                   keyFileVariable: 'mykey',
                                                   usernameVariable: 'myuser')]) {

                    echo "Delete existing pod and deployment"
                    sh "ssh ${myuser}@192.168.105.4 -i ${mykey} \"kubectl delete pod myapp --ignore-not-found && kubectl delete deployments myapp --ignore-not-found\""

                    sh 'ls -la'
                    sh 'echo "Copy service yaml file"'
                    sh "scp -o StrictHostKeychecking=no -i ${mykey} myapp.yml ${myuser}@192.168.105.4:"
                    
                    sh 'echo "Create pod"'
                    sh "ssh ${myuser}@192.168.105.4 -i ${mykey} \"kubectl run myapp --image=ttl.sh/fvaldes-docker-ruby-hw\""

                    sh 'echo "Refresh service"'
                    sh "ssh ${myuser}@192.168.105.4 -i ${mykey} \"kubectl apply -f myapp.yaml\""

                    sh 'echo "Create deployments"'
                    sh "ssh ${myuser}@192.168.105.4 -i ${mykey} \"kubectl create deployment myapp --image=ttl.sh/fvaldes-docker-ruby-hw && kubectl scale --replicas=2 deployment/myapp\""
                }
            }

        }
    }
}