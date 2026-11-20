# Plantilla Go, multi-etapa. La imagen final no tiene shell: el chequeo de salud lo hace el mismo binario.
# Ajusta: versión de Go, paquete principal, ruta de salud.

# --- Etapa 1: compilar un binario estático ---
FROM golang:1.23 AS build
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/app ./cmd/app

# --- Etapa 2: ejecutar ---
FROM gcr.io/distroless/static-debian12:nonroot

ARG APP_VERSION=dev
LABEL org.opencontainers.image.version="${APP_VERSION}"
ENV APP_VERSION=${APP_VERSION} PORT=8080

COPY --from=build /out/app /app
# El usuario "nonroot" (uid 65532) ya viene en la imagen distroless.
USER nonroot
EXPOSE 8080

# Distroless no trae curl ni shell: el binario acepta "-salud" y consulta su propio endpoint.
# Ejemplo en Go: if len(os.Args) > 1 && os.Args[1] == "-salud" { resp, err := http.Get("http://localhost:"+os.Getenv("PORT")+"/salud"); ... os.Exit(...) }
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=5 CMD ["/app", "-salud"]

ENTRYPOINT ["/app"]
