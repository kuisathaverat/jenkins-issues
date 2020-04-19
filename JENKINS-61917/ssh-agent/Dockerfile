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
RUN echo 'export PATH=$PATH:/usr/local/openjdk-8/bin' >> /etc/environment
ENV PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/openjdk-8/bin
ENTRYPOINT []
CMD [ "/bin/sh", "-c", "/usr/sbin/sshd -D -p 22"]
