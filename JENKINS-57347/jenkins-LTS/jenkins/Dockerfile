FROM jenkins/jenkins:lts
RUN install-plugins.sh docker pipeline-model-definition configuration-as-code timestamper jdk-tool
USER root
COPY ./jenkins_home/* /usr/share/jenkins/ref/
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/
USER jenkins
