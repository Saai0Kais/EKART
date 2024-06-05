pipeline {
    agent any
  
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/Saai0Kais/EKART.git'
            }
        }
        
        stage('Terraform init') {
            steps {
                sh 'cd /home/srv/Terraform'
                sh 'terraform init'
            }
        }
        
        stage('Terraform plan') {
            steps {
                 sh 'cd /home/srv/Terraform'
                 sh 'terraform plan'
            }
        }

       stage('Terraform apply') {
            steps {
                sh 'cd /home/srv/Terraform'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
