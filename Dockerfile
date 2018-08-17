FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /etc/doh/ \
    && apt-get update \
    && apt-get install -y --no-install-recommends nginx supervisor \
    && rm -rf /etc/nginx/sites-*/default \
 && rm -rf /var/lib/apt/lists/*
COPY set_log_format.sh /usr/local/bin/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY doh.conf /etc/nginx/conf.d/
COPY localhost.pem /etc/doh/
COPY localhost-key.pem /etc/doh/
COPY bin/doh-proxy /srv/doh-proxy
RUN set_log_format.sh /etc/nginx/nginx.conf

EXPOSE "80"
EXPOSE "443"

ENTRYPOINT ["/usr/bin/supervisord"]
