FROM amazoncorretto:17
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} config.jar
EXPOSE 8888
ENTRYPOINT ["java", "-jar", "/config.jar"]
