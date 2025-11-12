pipeline {
    agent any

    environment {
        TF_VAR_ssl_certificate     = credentials('tf_ssl_certificate')
        TF_VAR_ssl_certificate_key = credentials('tf_ssl_certificate_key')
        TF_VAR_prometheus_host     = credentials('tf_prometheus_host')
        TF_VAR_grafana_host        = credentials('tf_grafana_host')
        TF_VAR_grafana_user        = credentials('tf_grafana_user')
        TF_VAR_grafana_password    = credentials('tf_grafana_password')
    }

    options {
        ansiColor('xterm')
        timestamps()
    }

    stages {
        stage('Update Repository') {
      steps {
        sh 'git reset --hard'
        sh 'git pull origin main'
      }
        }

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
          // Espera confirmación manual antes de aplicar
          input message: '¿Deseas aplicar los cambios de Terraform?', ok: 'Sí, aplicar'
          sh 'terraform apply -var-file=terraform.tfvars'
        }
      }
        }
    }

    post {
        success {
      echo 'Terraform desplegado correctamente ✅'
        }
        failure {
      echo 'Ha fallado el pipeline ❌'
        }
    }
}
