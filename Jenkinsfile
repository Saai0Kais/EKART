pipeline {
    agent any
    
    tools {
        maven 'maven3'
        jdk 'jdk17'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Saai0Kais/EKART.git'
            }
        }
        
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        
        stage('Unit Tests') {
            steps {
                sh 'mvn test -DskipTests=true'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar'){
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=EKART -Dsonar.projectName=EKART \
                    -Dsonar.java.binaries=. '''
                }
            }
        }
        
        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: ' --scan ./', odcInstallation: 'DC'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('Lynis Security Scan') {
			steps {
					// Run Lynis security scan
				sh 'lynis audit system | ansi2html >> /var/lib/jenkins/workspace/FullStack-App/scanrep.html'
			}
		}
    
        stage('Build') {
            steps {
                sh 'mvn package -DskipTests=true'
            }
        }
        
        
        stage('Maven Depoly Nexus') {
			steps {
    			configFileProvider([configFile(fileId: 'global-maven', variable: 'mavensettings')])  {
    			sh "mvn -s $mavensettings clean deploy -DskipTests=true"
                }
            }
        }

        
        stage('Build & Tag Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker build -t saai0kais/ekart:latest -f docker/Dockerfile ."
                    }
                }
            }
        }
        
        stage('Trivy Scan') {
            steps {
                sh "trivy image saai0kais/ekart:latest > /var/lib/jenkins/workspace/FullStack-App/trivy.txt"
            }
        }
        
        stage('Docker Push Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                    sh "docker push saai0kais/ekart:latest"
                    }
                }
            }
        }
        
        stage('K8s Deploy') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k3s', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://192.168.140.101:6443') {
                sh "kubectl apply -f deploymentservice.yml -n webapps"
                sh "kubectl get svc -n webapps"
                }
            }
        }
        
        stage('Security Scan with Nikto') {
            steps {
                sh 'nikto -h 192.168.140.101:8070 -o /var/lib/jenkins/workspace/FullStack-App/reportNikto.html'
            }
 	    }
    }
    
    post {
		success {
			slackSend color: '#36a64f', message: "Deployment of the app to production succeeded!"
		}
		
		failure {
			slackSend color: '#ff0000', message: "Deployment of the app to production failed!"
		}
    }
}

