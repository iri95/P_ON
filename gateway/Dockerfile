FROM amazoncorretto:17
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} gateway.jar
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "/gateway.jar"]
