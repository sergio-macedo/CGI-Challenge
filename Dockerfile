
FROM alpine:latest

# Install required packages
RUN apk add --no-cache \
    curl \
    docker \
    openrc \
    nginx \
    bash \
    && rc-update add docker boot

    
# Expose port 80 for Nginx
EXPOSE 80
# Install Kind
RUN curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 && \
    chmod +x /usr/local/bin/kind

# Start Docker and Nginx
CMD ["sh", "-c", "service docker start && nginx && kind create cluster && tail -f /dev/null"]
