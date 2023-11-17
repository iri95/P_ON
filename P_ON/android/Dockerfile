FROM amazoncorretto:17
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} promise.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/promise.jar"]
