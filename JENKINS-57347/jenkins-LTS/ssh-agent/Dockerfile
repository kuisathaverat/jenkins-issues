FROM jenkinsci/ssh-slave
USER root
COPY ssh /home/jenkins/.ssh
RUN chown -R jenkins:jenkins /home/jenkins/ \
  && chmod 700 /home/jenkins/.ssh \
  && chmod 600 /home/jenkins/.ssh/*
