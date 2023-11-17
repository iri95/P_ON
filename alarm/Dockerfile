FROM amazoncorretto:17
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} alarm.jar
EXPOSE 8085
ENTRYPOINT ["java", "-jar", "/alarm.jar"]
