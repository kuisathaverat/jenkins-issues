pipelineJob('testjobs/ssh-agent') {
  definition {
    cps {
      script("""\
        pipeline {
          agent { label 'ssh-agent'}
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
