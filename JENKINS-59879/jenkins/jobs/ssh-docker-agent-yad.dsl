pipelineJob('testjobs/ssh-docker-agent-yad') {
  definition {
    cps {
      script("""\
        pipeline {
          agent { label 'docker-yad-ssh'}
          stages {
            stage ('test') {
              steps {
                echo "hello"
              }
            }
          }
        }""".stripIndent())
        sandbox(true)
    }
  }
}
