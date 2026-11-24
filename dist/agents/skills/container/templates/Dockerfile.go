# Go template (multi-stage). The final image has no shell: the binary checks its own health.
# Adjust: Go version, main package, health route.

# --- Stage 1: build a static binary ---
FROM golang:1.23 AS build
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/app ./cmd/app

# --- Stage 2: run ---
FROM gcr.io/distroless/static-debian12:nonroot

ARG APP_VERSION=dev
LABEL org.opencontainers.image.version="${APP_VERSION}"
ENV APP_VERSION=${APP_VERSION} PORT=8080

COPY --from=build /out/app /app
# The "nonroot" user (uid 65532) ships with the distroless image.
USER nonroot
EXPOSE 8080

# Distroless has no curl and no shell: the binary accepts "-health" and calls its own endpoint.
# Go example: if len(os.Args) > 1 && os.Args[1] == "-health" { resp, err := http.Get("http://localhost:"+os.Getenv("PORT")+"/health"); ... os.Exit(...) }
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=5 CMD ["/app", "-health"]

ENTRYPOINT ["/app"]
