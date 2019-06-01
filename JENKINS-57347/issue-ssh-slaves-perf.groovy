pipeline {
  agent { label 'ssh-agent' }
  options {
    buildDiscarder(logRotator(numToKeepStr:'300'))
    timestamps()
  }
  parameters {
    string ( name: 'ITERATIONS', defaultValue: '10', description: 'How many times to run the loop')
  }
  stages {
      stage ('One') {
          steps {
              script {
                  for ( i = 0; i < params.ITERATIONS.toInteger(); i++) {
                      def hostname = sh (script: "/bin/bash -c 'time hostname'", returnStdout: true)
                      echo hostname
                  }
              }
          }
        }
  }
}
