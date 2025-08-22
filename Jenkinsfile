pipeline {
  agent any
  options { timestamps(); ansiColor('xterm') }
  environment {
    REGISTRY = "docker.io/${DOCKERHUB_USERNAME}/ci-cd-projet"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }

    stage('Set variables') {
      steps {
        script {
          if (env.BRANCH_NAME == 'dev') {
            env.IMAGE_TAGS = "test"
          } else if (env.BRANCH_NAME == 'main') {
            env.IMAGE_TAGS = "stable,latest"
          } else {
            error("Branche non gérée (utilise dev ou main).")
          }
        }
      }
    }

    stage('Docker build') {
      steps { sh 'docker build -t $REGISTRY:build-$BRANCH_NAME-$BUILD_NUMBER .' }
    }

    stage('Docker login & push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            IFS=',' read -ra TAGS <<< "$IMAGE_TAGS"
            for t in "${TAGS[@]}"; do
              docker tag $REGISTRY:build-$BRANCH_NAME-$BUILD_NUMBER $REGISTRY:$t
              docker push $REGISTRY:$t
            done
            docker logout
          '''
        }
      }
    }
  }
}

