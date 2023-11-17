ARG TAG=2.426.1
FROM jenkins/jenkins:${TAG}
USER root
COPY ./jenkins_home/jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml
COPY ./jenkins_home/plugins.txt /usr/share/jenkins/ref/
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
RUN touch /var/run/docker.sock \
  && chown jenkins:jenkins /var/run/docker.sock
USER jenkins
