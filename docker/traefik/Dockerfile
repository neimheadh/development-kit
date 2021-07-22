ARG FROM_IMAGE=traefik
FROM ${FROM_IMAGE}

RUN mkdir -p /etc/traefik
COPY traefik.yml 	/etc/traefik/traefik.yml
COPY ./conf.d		/etc/traefik/conf.d