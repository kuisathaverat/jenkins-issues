FROM jenkins/jenkins:2.214
USER root
COPY ./jenkins_home/* /usr/share/jenkins/ref/
COPY ./jenkins_home/.ssh/* /usr/share/jenkins/ref/.ssh/
COPY ./jobs /usr/share/jenkins/ref/jobs
RUN chmod -R 700 /usr/share/jenkins/ref/.ssh
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/
RUN install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
RUN sed -i /etc/ssh/ssh_config \
        -e 's/HashKnownHosts.*/HashKnownHosts no/'
USER jenkins
