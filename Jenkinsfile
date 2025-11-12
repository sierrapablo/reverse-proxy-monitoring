pipeline {
    agent any

    stages {
        stage('Terraform Init') {
      steps {
        dir('terraform') {
          sh 'terraform init'
        }
      }
        }

        stage('Terraform Plan') {
      steps {
        dir('terraform') {
          sh 'terraform plan -var-file=terraform.tfvars'
        }
      }
        }

        stage('Terraform Apply') {
      steps {
        dir('terraform') {
          input message: '¿Deseas aplicar los cambios de Terraform?', ok: 'Sí, aplicar'
          sh 'terraform apply -var-file=terraform.tfvars'
        }
      }
        }
    }

    post {
        success {
      echo 'Terraform y Docker desplegados correctamente ✅'
        }
        failure {
      echo 'Ha fallado el pipeline ❌'
        }
    }
}
