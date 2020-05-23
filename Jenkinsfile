pipeline {
	agent any
  options {skipStagesAfterUnstable()}
  environment {
        GIT_COMMIT_HASH = "${sh(script:"git log -1 --pretty=format:'%h'", returnStdout: true)}"
        GIT_COMMITTER_NAME = "${sh(script:"git log -1 --pretty=format:'%cn'", returnStdout: true)}"
    }

  stages {
    stage('build') {
      steps {
        sh 'docker build -t gitlab.techverito.com:4567/internal/blog:${BUILD_NUMBER} .'
        sh 'docker push gitlab.techverito.com:4567/internal/blog:${BUILD_NUMBER}'
      }
    }
    stage('test') {
      steps {
        sh './testing.sh'
      }
    }
    stage('Deploy') {
      steps {
        sh './deploy_production.sh'
      }
    }
  }
  post {
    always {
      sh 'docker rmi -f gitlab.techverito.com:4567/internal/blog:${BUILD_NUMBER}'
      sh 'docker-compose down'
    }
    success {
      slackSend channel: '#blog_notification',
      color: 'good',
      message: """"Build for ${currentBuild.fullDisplayName} was SUCCESSFUL.
      Build Number: ${BUILD_NUMBER }
      Change Commiter: ${env.GIT_COMMITTER_NAME}
      Commit ID ${env.GIT_COMMIT_HASH}"""
    }
    failure {
      slackSend channel: '#blog_notification',
      color: 'red',
      message: """Build for ${currentBuild.fullDisplayName} FAILED. 
      Build Number: ${BUILD_NUMBER }
      Change Commiter: ${env.GIT_COMMITTER_NAME}
      Commit ID: ${env.GIT_COMMIT_HASH}"""
    }
  }
}