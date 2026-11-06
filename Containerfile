
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bind9 \
       bind9-utils \
       ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# DNS service ports
EXPOSE 53/tcp 53/udp

# Run BIND in the foreground for container management
CMD ["/usr/sbin/named", "-g", "-u", "bind"]
