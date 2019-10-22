# Build dnsmasq container

FROM alpine:latest

RUN apk add --no-cache dnsmasq

RUN touch /etc/hosts.dnsmasq

EXPOSE 53 53/udp

ENTRYPOINT [ "/usr/sbin/dnsmasq", "--no-daemon", "--no-hosts" ]
CMD [ "--addn-hosts=/etc/hosts.dnsmasq" ]

