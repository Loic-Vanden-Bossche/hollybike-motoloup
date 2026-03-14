FROM debian:bookworm-slim

ARG EXECUTABLE
ARG OCI_IMAGE_DESCRIPTION="HollyBike backend API"

LABEL org.opencontainers.image.description="${OCI_IMAGE_DESCRIPTION}"

COPY build/native/nativeCompile/$EXECUTABLE /app/hollybike_server

RUN apt-get update && apt-get install -y curl

RUN chmod +x /app/hollybike_server

ENTRYPOINT ["/app/hollybike_server"]
