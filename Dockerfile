# # # Use an Alpine base image for a lightweight container
# # FROM --platform=arm64 alpine:3.18 as development

# # # Install dependencies: curl, bash, Docker, and Nginx
# # RUN apk add --no-cache curl bash docker nginx

# # # Install kubectl
# # RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
# #     chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# # # Install Kind
# # RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 && \
# #     chmod +x ./kind && mv ./kind /usr/local/bin/kind

# # # Create the startup script with correct line endings
# # RUN echo -e '#!/bin/sh\nnginx -g "daemon off;" &\nkind create cluster\nexec tail -f /dev/null' > /start.sh && \
# #     chmod +x /start.sh

# # RUN echo '<h1>Hello, World!</h1>' > /usr/share/nginx/html/index.html

# # # Expose ports
# # EXPOSE 80 6443

# # # Command to run the script
# # CMD ["sh", "/start.sh"]

# # Use a Node.js base image that supports multiple architectures
# # Use a Node.js base image that supports multiple architectures
# # Use a Node.js base image
# FROM node:18-buster

# # Set working directory
# WORKDIR /usr/src/app

# # Copy package.json and package-lock.json
# COPY package*.json ./

# # Install dependencies
# RUN npm install

# # Install AWS CLI dependencies
# RUN apt-get update && apt-get install -y \
#     unzip \
#     curl \
#     && rm -rf /var/lib/apt/lists/*

# # Install AWS CLI v2
# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
#     unzip awscliv2.zip && \
#     ./aws/install && \
#     rm -rf awscliv2.zip aws/

# # Copy the rest of the application code
# COPY . .

# # Expose the port the app runs on
# EXPOSE 3000

# # Command to run the app
# CMD ["node", "server.js"]
