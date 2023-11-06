FROM amazoncorretto:17
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} vote.jar
EXPOSE 8084
ENTRYPOINT ["java", "-jar", "/vote.jar"]
