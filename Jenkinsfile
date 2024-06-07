pipeline {
    agent any
  
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'DeployVM', url: 'https://github.com/Saai0Kais/EKART.git'
            }
        }
        
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Terraform plan') {
            steps {
                 sh 'terraform plan'
            }
        }

       stage('Terraform apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }

      post {
		success {
			slackSend color: '#36a64f', message: "Deployment of the vm to cloud succeeded!"
		}
		
		failure {
			slackSend color: '#ff0000', message: "Deployment of the vm to cloud failed!"
		}
    }
}
