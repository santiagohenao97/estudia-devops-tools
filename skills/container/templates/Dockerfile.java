# Java template (Maven, multi-stage). Adjust: Java version, jar name, health route.
# With Gradle: use gradle:8-jdk21 and "gradle bootJar --no-daemon"; the jar lands in build/libs/.

# --- Stage 1: build ---
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q package -DskipTests

# --- Stage 2: run (no compiler, no Maven) ---
FROM eclipse-temurin:21-jre

ARG APP_VERSION=dev
ARG REVISION=unknown
LABEL org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.revision="${REVISION}"
ENV APP_VERSION=${APP_VERSION} PORT=8080

RUN useradd --system --uid 10001 app && mkdir /data && chown app /data
WORKDIR /srv
COPY --from=build /build/target/*.jar app.jar
USER app
VOLUME /data
EXPOSE 8080

# Make sure the image has curl (docker run --rm <image> which curl). If not, install it in this stage
# or move the health check to Compose. Spring Boot exposes /actuator/health; otherwise use /health.
HEALTHCHECK --interval=10s --timeout=3s --start-period=30s --retries=5 \
  CMD curl -fsS "http://localhost:${PORT}/actuator/health" || exit 1

ENTRYPOINT ["java", "-jar", "/srv/app.jar"]
