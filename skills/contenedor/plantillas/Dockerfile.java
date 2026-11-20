# Plantilla Java con Maven, multi-etapa. Ajusta: versión de Java, nombre del jar, ruta de salud.
# Con Gradle: usa gradle:8-jdk21 y "gradle bootJar --no-daemon"; el jar queda en build/libs/.

# --- Etapa 1: compilar ---
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q package -DskipTests

# --- Etapa 2: ejecutar (sin compilador ni Maven) ---
FROM eclipse-temurin:21-jre

ARG APP_VERSION=dev
ARG REVISION=desconocida
LABEL org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.revision="${REVISION}"
ENV APP_VERSION=${APP_VERSION} PORT=8080

RUN useradd --system --uid 10001 app && mkdir /data && chown app /data
WORKDIR /srv
COPY --from=build /build/target/*.jar app.jar
USER app
VOLUME /data
EXPOSE 8080

# Comprueba que la imagen tenga curl (docker run --rm <imagen> which curl). Si no, usa el actuator
# de Spring desde Compose o instala curl en esta etapa.
HEALTHCHECK --interval=10s --timeout=3s --start-period=30s --retries=5 \
  CMD curl -fsS "http://localhost:${PORT}/actuator/health" || exit 1

ENTRYPOINT ["java", "-jar", "/srv/app.jar"]
