FROM maven:3.5-jdk-8-alpine AS build

WORKDIR /code

COPY worker/java/src/pom.xml /code/pom.xml
RUN ["mvn", "dependency:resolve"]
RUN ["mvn", "verify"]

# Adding source, compile and package into a fat jar
COPY ["worker/java/src/main", "/code/src/main"]
RUN ["mvn", "package"]

FROM openjdk:8-jre-alpine

COPY --from=build /code/target/worker-jar-with-dependencies.jar /

CMD ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-jar", "/worker-jar-with-dependencies.jar"]
