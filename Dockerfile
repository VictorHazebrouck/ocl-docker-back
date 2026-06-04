FROM gradle:8.7-jdk21 AS builder

WORKDIR /app

COPY . .

RUN gradle clean bootWar --no-daemon

FROM tomcat:10.1.24-jdk21-temurin AS runner

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /app/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
