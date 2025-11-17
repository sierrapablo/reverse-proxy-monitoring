pipeline {
  agent any

  environment {
    TF_IN_AUTOMATION = 'true'
    TF_CLI_ARGS = '-no-color'
  }

  stages {
    stage('CHECKOUT') { steps { checkout scm } }

    stage('CHECK PREQUISITES') {
      steps {
        dir('terraform') {
          sh '''
            if [ ! -f "../ssl/fullchain.pem" ] || [ ! -f "../ssl/server.key" ]; then
            echo "ERROR: SSL certificates missing in ssl/"
            exit 1
            fi
            if [ ! -f "../.htpasswd" ]; then
            echo "ERROR: .htpasswd file missing in project root"
            exit 1
            fi
            echo "All prerequisites present."
          '''
        }
      }
    }

    stage('TERRAFORM INIT') {
      steps {
        dir('terraform') { sh 'terraform init' }
      }
    }

    stage('TERRAFORM FORMAT') {
      steps {
        dir('terraform') { sh 'terraform fmt -check' }
      }
    }

    stage('TERRAFORM VALIDATE') {
      steps {
        dir('terraform') { sh 'terraform validate' }
      }
    }

    stage('TERRAFORM PLAN') {
      steps {
        dir('terraform') { sh 'terraform plan -out=tfplan' }
      }
    }

    stage('APPROVAL BEFORE APPLY') {
      steps { input message: '¿Aplicar cambios de Terraform?' }
    }

    stage('TERRAFORM APPLY') {
      steps {
        dir('terraform') { sh 'terraform apply -auto-approve tfplan' }
      }
    }
  }

  post {
    always { dir('terraform') { sh 'rm -f tfplan' } }
    success { echo 'Terraform ejecutado correctamente.' }
    failure { echo 'La pipeline ha fallado.' }
  }
}
