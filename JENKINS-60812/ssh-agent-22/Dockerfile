FROM jenkinsci/ssh-slave
USER root
COPY ssh /home/jenkins/.ssh
RUN chown -R jenkins:jenkins /home/jenkins/ \
  && chmod 700 /home/jenkins/.ssh \
  && chmod 600 /home/jenkins/.ssh/*
COPY ssh /root/.ssh
RUN chown -R root:root /root/ \
  && chmod 700 /root/.ssh \
  && chmod 600 /root/.ssh/*
RUN ssh-keygen -A
RUN sed -i /etc/ssh/sshd_config \
        -e 's/PermitRootLogin.*/PermitRootLogin yes/'
RUN echo "password\npassword" | passwd root \
  && echo "password\npassword" | passwd jenkins

EXPOSE 22

ENTRYPOINT []
RUN echo PATH=/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin >> /etc/environment
CMD [ "/bin/sh", "-c", "/usr/sbin/sshd -D -p 22"]
