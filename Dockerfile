# Use an Alpine base image for a lightweight container
FROM alpine:3.18

# Install dependencies: curl, bash, Docker, and Nginx
RUN apk add --no-cache curl bash docker nginx

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# Install Kind
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 && \
    chmod +x ./kind && mv ./kind /usr/local/bin/kind

# Set up Nginx to run as a service
RUN mkdir -p /run/nginx

# Expose port 80 for Nginx
EXPOSE 80

# Define the startup command to run Nginx and create a Kind cluster
CMD ["bash", "-c", "service nginx start && kind create cluster && tail -f /dev/null"]
