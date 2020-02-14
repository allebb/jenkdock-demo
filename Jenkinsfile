pipeline {
  agent {
    docker {
      image 'allebb/phptestrunner-74:latest'
      args '-v $HOME:/var/www/html'
    }

  }
  stages {
    stage('Check PHP Version') {
      steps {
        sh 'php -v'
      }
    }

  }
}