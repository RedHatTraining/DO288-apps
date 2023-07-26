FROM registry.access.redhat.com/ubi8/openjdk-17:1.16

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src src
RUN mvn clean package

CMD ["java", "-jar", "target/quarkus-app/quarkus-run.jar"]
