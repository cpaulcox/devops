FROM ubuntu:19.10

RUN apt update -y && apt install -y curl unzip

# https://adoptopenjdk.net/releases.html?variant=openjdk13&jvmVariant=hotspot

RUN mkdir -p /etc/jdk && mkdir -p /etc/kotlin

RUN curl -L https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13.0.2%2B8/OpenJDK13U-jdk_arm_linux_hotspot_13.0.2_8.tar.gz -o /etc/jdk/jdk.tar.gz

RUN cd /etc/jdk && tar xvf jdk.tar.gz && rm jdk.tar.gz && mv jdk* jdk

RUN curl -L https://github.com/JetBrains/kotlin/releases/download/v1.3.70/kotlin-compiler-1.3.70.zip -o /etc/kotlin/kt-comp.zip

RUN cd /etc/kotlin && unzip kt-comp.zip && rm kt-comp.zip

ENV JAVA_HOME /etc/jdk/jdk
ENV PATH="$PATH:/etc/kotlin/kotlinc/bin"
#CMD bash
