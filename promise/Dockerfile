FROM amazoncorretto:17
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} promise.jar
ENTRYPOINT ["java", "-jar", "/promise.jar"]
