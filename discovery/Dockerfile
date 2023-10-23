FROM amazoncorretto:17
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} discovery.jar
EXPOSE 8761
ENTRYPOINT ["java", "-jar", "/discovery.jar"]
