FROM registry.access.redhat.com/ubi8/openjdk-17:1.16 as builder

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src src
RUN mvn clean package

FROM registry.access.redhat.com/ubi8/openjdk-17:1.16

COPY --from=builder /home/jboss/target/quarkus-app .

CMD ["java", "-jar", "quarkus-run.jar"]