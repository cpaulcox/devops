# Long term support version by default
ARG version="lts"

FROM jenkins/jenkins:$version

# define env variables
ENV JENKINS_REF="/usr/share/jenkins/ref"

ENV CASC_JENKINS_CONFIG="/usr/share/jenkins/casc"

# define JVM options
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false \
              -Duser.timezone=Europe/London

USER root 
RUN apt -y install git

RUN curl https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | tar xvz -C /tmp/ && \
  mv /tmp/docker/docker /usr/bin/docker

USER jenkins

# install jenkins plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# copy jenkins CASC configuration
COPY jenkins_config/casc_configs $CASC_JENKINS_CONFIG

