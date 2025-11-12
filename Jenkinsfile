pipeline {
  agent any

  stages {
    stage('Clone Repo') {
      steps {
        dir('/repos/devops-nginx/reverse-proxy-monitoring') {
          sh 'git fetch origin main && git reset --hard origin/main'
        }
      }
    }

    stage('Docker Compose Down') {
      steps {
        dir('/repos/devops-nginx/reverse-proxy-monitoring') {
          sh 'docker compose down || true'
        }
      }
    }

    stage('Docker Compose Up') {
      steps {
        dir('/repos/devops-nginx/reverse-proxy-monitoring') {
          sh 'docker compose up -d --build'
        }
      }
    }
  }

  post {
    success {
      echo 'Docker desplegado correctamente ✅'
    }
    failure {
      echo 'Ha fallado el pipeline ❌'
      dir('/repos/devops-nginx/reverse-proxy-monitoring') {
        sh 'docker compose down'
      }
    }
  }
}
