# Use the official Nginx image
FROM haproxy:alpine

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

EXPOSE 8888
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
