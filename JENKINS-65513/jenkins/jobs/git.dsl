pipelineJob('testjobs/ssh-agent-git') {
  definition {
    cps {
      script("""\
        pipeline {
          agent { label 'ssh-agent'}
          stages {
            stage ('test') {
              steps {
                git credentialsId: 'local-id-rsa', url: 'git@github.com:jenkinsci/ssh-slaves-plugin.git'
              }
            }
          }
        }""".stripIndent())
        sandbox(true)
    }
  }
}
