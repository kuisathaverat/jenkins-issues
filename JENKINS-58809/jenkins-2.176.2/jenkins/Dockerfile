FROM jenkins/jenkins:2.176.2
RUN install-plugins.sh saml docker pipeline-model-definition configuration-as-code timestamper jdk-tool
USER root
COPY ./jenkins_home/* /usr/share/jenkins/ref/
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/
RUN cat /usr/share/jenkins/ref/jenkins.yaml
USER jenkins
