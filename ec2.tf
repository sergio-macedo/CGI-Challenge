resource "aws_key_pair" "wsl_key_pair" {
  key_name   = "wsl_key_pair"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "allow_ec2" {
  name        = "allow_ec2"
  description = "Allow SSH and other necessary ports"
  vpc_id      = aws_vpc.cgi_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_sg.id]

  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_sg.id]
  }
}

resource "aws_instance" "cgi_node_instance" {
  count                       = length(var.azs)
  subnet_id                   = aws_subnet.CGI_challenge_pub_subnet[count.index].id
  ami                         = "ami-0df0e7600ad0913a9"
  instance_type               = "t2.medium"
  security_groups             = [aws_security_group.allow_ec2.id]
  key_name                    = aws_key_pair.wsl_key_pair.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  associate_public_ip_address = true


  user_data = <<-EOF
             #!/bin/bash

# Log everything for debugging
exec > /var/log/user-data.log 2>&1
set -x

# Update the package list
sudo apt-get update -y

# Install necessary dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Install Kubernetes tools
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF'
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Disable swap (required by Kubernetes)
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Initialize Kubernetes master node (ignore errors for existing config)
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 || true

# Set up kubeconfig for root (or ubuntu user)
sudo mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
sudo chown $(id -u):$(id -g) /root/.kube/config

# Install Flannel for networking
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel.yaml

# Deploy simple Hello World application
sudo kubectl run hello-world --image=nginx --port=80

# Expose the Hello World service via a LoadBalancer
sudo kubectl expose deployment hello-world --type=LoadBalancer --port=80 --target-port=80

# Ensure services are started properly
sudo systemctl restart kubelet docker
              EOF

  tags = {
    Name = "node-EC2"
  }

}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.eks_unified_role.name
}

