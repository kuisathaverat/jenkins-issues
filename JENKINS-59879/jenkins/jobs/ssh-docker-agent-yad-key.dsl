pipelineJob('testjobs/ssh-docker-agent-yad-key') {
  definition {
    cps {
      script("""\
        pipeline {
          agent { label 'ssh-docker-agent'}
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
