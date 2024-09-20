# # Use a base image with Kind installed
# FROM alpine:3.20.3 as builder

# # Install curl
# RUN apk add --no-cache curl

# # Install Kind
# RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 && \
#     chmod +x ./kind && \
#     mv ./kind /usr/local/bin/kind

# # Install Docker (Kind requires Docker to run Kubernetes nodes)
# RUN apt-get update && \
#     apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
#     curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
#     add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
#     apt-get update && \
#     apt-get install -y docker-ce docker-ce-cli containerd.io

# # Install Nginx
# RUN apt-get install -y nginx

# # Install Kubectl
# RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
#     chmod +x kubectl && \
#     mv kubectl /usr/local/bin/kubectl

# # Expose port 80 for Nginx
# EXPOSE 80

# # Command to start Nginx and Kind
# CMD service nginx start && kind create cluster && tail -f /dev/null

# Use Alpine as the base image
FROM alpine:latest

# Install required packages
RUN apk add --no-cache \
    curl \
    docker \
    openrc \
    nginx \
    bash \
    && rc-update add docker boot

# Install Kind
RUN curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 && \
    chmod +x /usr/local/bin/kind

# Start Docker and Nginx
CMD ["sh", "-c", "service docker start && nginx && kind create cluster && tail -f /dev/null"]

# Expose port 80 for Nginx
EXPOSE 80