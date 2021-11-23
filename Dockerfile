FROM openjdk:8u302

WORKDIR /root
COPY appinventor appinventor/

COPY start_appinventor.sh start_appinventor.sh 
RUN chmod +x start_appinventor.sh

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y libc6:i386 zlib1g:i386 libstdc++6:i386 ant zip unzip

RUN mkdir -p /opt/appengine && \
    wget --no-verbose -O /tmp/appengine.zip https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.68.zip &&\
    unzip -o /tmp/appengine.zip -d /opt/appengine

RUN cd appinventor && \
    ant MakeAuthKey && \
    ant -Drelease=true

#VOLUME [ "/root" ]
VOLUME [ "/root/appinventor/appengine/build/war/WEB-INF/appengine-generated" ]
EXPOSE 8888
CMD [ "./start_appinventor.sh" ]
#CMD ["/opt/appengine/appengine-java-sdk-1.9.68/bin/dev_appserver.sh", "--port=8888", "--address=0.0.0.0", "appinventor/appengine/build/war/"]