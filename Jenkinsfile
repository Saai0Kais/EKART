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
