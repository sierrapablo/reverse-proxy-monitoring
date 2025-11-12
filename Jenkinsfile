pipeline {
  agent any

  stages {
    stage('Docker Compose Down') {
      steps {
        dir('devops-nginx') { sh 'docker compose down || true' }
      }
    }

    stage('Docker Compose Up') {
      steps {
        dir('devops-nginx') { sh 'docker compose up -d --build' }
      }
    }
  }

  post {
    success { echo 'Docker desplegado correctamente ✅' }
    failure { echo 'Ha fallado el pipeline ❌' }
  }
}
