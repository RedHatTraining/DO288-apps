FROM registry.ocp4.example.com:8443/ubi8/openjdk-17:1.16

COPY settings.xml /home/jboss/.m2/settings.xml
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src src
RUN mvn clean package

CMD ["java", "-jar", "target/expense-service-1.0.0-SNAPSHOT-runner.jar"]
