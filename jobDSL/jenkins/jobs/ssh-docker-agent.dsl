pipelineJob('testjobs/ssh-docker-agent') {
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
    }
  }
}
