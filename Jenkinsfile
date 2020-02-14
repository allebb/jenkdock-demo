pipeline {
  environment {
    registry = 'https://registry.hub.docker.com'
    imageRepoName = 'allebb/jenkdock'
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  stages {
     stage('Clone') {
      steps {
        git 'https://github.com/allebb/jenkdock-demo.git'
      }
    }
    stage('Test') {
      agent {
        docker {
          image 'allebb/phptestrunner-74:latest'
          args '-u root:sudo'
        }
      }
      steps {
        echo 'Building test environment'
        sh 'php -v'
        echo 'Installing Composer'
        sh 'curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer'
        echo 'Installing PHPLoc...'
        sh 'composer global require phploc/phploc --no-progress'
        echo 'Installing PHPMD...'
        sh 'composer global require phpmd/phpmd --no-progress'
        echo 'Installing project composer dependencies...'
        sh 'cd $WORKSPACE && composer install --no-progress'
        echo 'Running PHPUnit tests...'
        sh 'php $WORKSPACE/vendor/bin/phpunit --coverage-html $WORKSPACE/report/clover --coverage-clover $WORKSPACE/report/clover.xml --log-junit $WORKSPACE/report/junit.xml'
        echo 'Running PHPLoc...'
        sh 'php /root/.composer/vendor/bin/phploc lib'
        echo 'Running PHPMD...'
        sh 'php /root/.composer/vendor/bin/phpmd lib text cleancode,codesize,controversial,design,naming,unusedcode --ignore-violations-on-exit'
        sh 'chmod -R a+w $PWD && chmod -R a+w $WORKSPACE'
        junit 'report/*.xml'
      }
    }

    stage('Build') {
      agent any
      steps {
        echo 'Building container image...'
        script {
          dockerImage = docker.build(imageRepoName)
        }

      }
    }

    stage('Deploy') {
      steps {
        echo 'Deploying container to registry...'
        script {
           docker.withRegistry(registry, registryCredential) {
             dockerImage.push("${env.BUILD_NUMBER}")
             dockerImage.push("latest")
           }
         }
      }
    }

    stage('Cleanup') {
      steps{
        sh "docker rmi $imageRepoName:$BUILD_NUMBER"
        sh "docker rmi $imageRepoName:latest"
      }
    }

  }
}
