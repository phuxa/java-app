FROM maven:3.6.3-jdk-11-slim AS build
COPY src /home/phu_xv97/java-app/java-app/src
COPY pom.xml /home/phu_xv97/java-app/java-app
RUN mvn -f /home/phu_xv97/java-app/java-app/pom.xml clean package

FROM openjdk:11-jdk-slim

COPY --from=build /home/phu_xv97/java-app/java-app/target/k8s-0.0.1-SNAPSHOT.jar  /usr/app/k8s-0.0.1-SNAPSHOT.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/app/k8s-0.0.1-SNAPSHOT.jar"]
