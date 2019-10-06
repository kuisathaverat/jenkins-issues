pipelineJob('testjobs/ssh-agent') {
  definition {
    cps {
      script("""\
        pipeline {
          agent { label 'ssh-agent'}
          stages {
            stage ('test') {
              steps {
                git credentialsId: 'github-ssh', url: 'git@github.com:jenkinsci/ssh-slaves-plugin.git'
              }
            }
          }
        }""".stripIndent())
    }
  }
}
