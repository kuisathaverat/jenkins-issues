ARG JENKINS_VERSION=2.230
FROM jenkins/jenkins:${JENKINS_VERSION}
USER root
COPY ./jenkins_home/* /usr/share/jenkins/ref/
COPY ./jobs /usr/share/jenkins/ref/jobs
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/
RUN install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
USER jenkins
