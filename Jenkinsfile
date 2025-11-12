pipeline {
  agent any

  stages {

    stage('Docker Compose Down') {
      steps {
        dir('/var/jenkins_home/workspace/devops/reverse-proxy') {
          sh 'docker compose down || true'
        }
      }
    }

    stage('Docker Compose Up') {
      steps {
        dir('/var/jenkins_home/workspace/devops/reverse-proxy') {
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
      dir('/var/jenkins_home/workspace/devops/reverse-proxy') {
        sh 'docker compose down'
      }
    }
  }
}
