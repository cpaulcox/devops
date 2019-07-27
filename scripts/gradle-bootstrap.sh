#!/bin/bash

# JDK
curl https://cdn.azul.com/zulu/bin/zulu11.2.3-jdk11.0.1-linux_x64.tar.gz | tar -xz

mv zulu11.2.3-jdk11.0.1-linux_x64 jdk11

# Gradle

curl -L -o gradle.zip https://services.gradle.org/distributions/gradle-5.1.1-bin.zip

unzip gradle.zip

echo export PATH=$PATH:~/gradle-5.1.1/bin:~/jdk11/bin >> .bashrc
echo export JAVA_HOME=~/jdk11 >> .bashrc


