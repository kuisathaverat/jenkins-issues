pipelineJob('testjobs/docker-agent') {
  definition {
    cps {
      script("""\
        pipeline {
          agent { label 'docker-agent'}
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
