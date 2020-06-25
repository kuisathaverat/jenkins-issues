ARG TAG=2.241
FROM jenkins/jenkins:${TAG}
USER root
COPY ./jenkins_home/* /usr/share/jenkins/ref/
COPY ./jobs /usr/share/jenkins/ref/jobs
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/
RUN install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
USER jenkins
