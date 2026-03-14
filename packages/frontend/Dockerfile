FROM nginx:alpine

ARG OCI_IMAGE_DESCRIPTION="HollyBike frontend web application"
LABEL org.opencontainers.image.description="${OCI_IMAGE_DESCRIPTION}"

COPY ./dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
