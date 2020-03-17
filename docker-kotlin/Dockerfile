FROM debian:stable-slim
#ENV LANG en_US.UTF-8
#ENV LANGUAGE en_US:en
#ENV LC_ALL en_US.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/zulu-12

# http://cdn.azul.com/zulu-embedded/bin/zulu11.31.16-ca-jdk11.0.3-linux_aarch32hf.tar.gz

RUN apt update && \
    apt upgrade -y && \
    apt-get install -y wget unzip

RUN ZULU_ARCH=zulu11.31.16-ca-jdk11.0.3-linux_aarch32hf.tar.gz && \
    INSTALL_DIR=$( dirname $JAVA_HOME ) && \
    BIN_DIR=/usr/bin && \
    MAN_DIR=/usr/share/man/man1 && \
    ZULU_DIR=$( basename ${ZULU_ARCH} .tar.gz ) && \
    wget -q https://cdn.azul.com/zulu-embedded/bin/${ZULU_ARCH} && \
    mkdir -p ${INSTALL_DIR} && \
    tar -xf ./${ZULU_ARCH} -C ${INSTALL_DIR} && rm -f ${ZULU_ARCH} && \
    mv ${INSTALL_DIR}/${ZULU_DIR} ${JAVA_HOME} && \
    cd ${BIN_DIR} && find ${JAVA_HOME}/bin -type f -perm -a=x -exec ln -s {} . \; && \
    mkdir -p ${MAN_DIR} && \
    cd ${MAN_DIR} && find ${JAVA_HOME}/man/man1 -type f -name "*.1" -exec ln -s {} . \;

ARG kotlin_version=1.3.70

LABEL description="Kotlin ${kotlin_version}"

ENV KOTLIN_ROOT /opt/kotlinc
ENV KOTLIN_VERSION ${kotlin_version}
ENV PATH $PATH:$KOTLIN_ROOT/bin

RUN wget https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip -O /tmp/kotlin.zip && \
	mkdir -p /opt && \
    unzip /tmp/kotlin.zip -d /opt \
    && rm -v /tmp/kotlin.zip \
    && java -version \
    && kotlin -version

RUN uname -a && \
    cat /etc/*-release

#ENTRYPOINT ["kotlin"] 
