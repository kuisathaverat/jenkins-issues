FROM ubuntu:18.04
USER root

RUN apt-get update -y -qq \
  &&  apt-get install -y -qq \
    openssh-server \
    software-properties-common

RUN add-apt-repository ppa:openjdk-r/ppa -y \
  && apt-get update -y -qq \
  && apt-get install -y -qq \
    openjdk-8-jdk \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --password password --shell /bin/bash --uid 1000 jenkins \
  && mkdir /home/jenkins \
  && chown -R jenkins:jenkins /home/jenkins

COPY ssh /home/jenkins/.ssh
RUN chown -R jenkins:jenkins /home/jenkins/ \
  && chmod 700 /home/jenkins/.ssh \
  && chmod 600 /home/jenkins/.ssh/*
COPY ssh /root/.ssh
RUN chown -R root:root /root/ \
  && chmod 700 /root/.ssh \
  && chmod 600 /root/.ssh/*
RUN ssh-keygen -A
COPY ssh/sshd_config /etc/ssh/sshd_config
RUN mkdir -p  /var/run/sshd

RUN echo "password\npassword" | passwd root \
  && echo "password\npassword" | passwd jenkins

EXPOSE 22
RUN echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/jvm/java-8-openjdk-amd64/jre/bin:/usr/lib/jvm/java-8-openjdk-amd64/bin' >> /etc/environment
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/jvm/java-8-openjdk-amd64/jre/bin:/usr/lib/jvm/java-8-openjdk-amd64/bin
ENTRYPOINT []
CMD [ "/bin/sh", "-c", "/usr/sbin/sshd -e -D -p 22"]
