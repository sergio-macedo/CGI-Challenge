# resource "aws_key_pair" "cgi_kind_key" {
#   key_name   = "cgi-kind-key"
#   public_key = var.ssh_public_key
# }

# resource "aws_security_group" "allow_ssh" {
#   name        = "allow_ssh"
#   description = "Allow SSH and other necessary ports"
#   vpc_id      = 

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 30080
#     to_port     = 30080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 6443
#     to_port     = 6443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


# resource "aws_instance" "cgi_kind_instance" {
#   subnet_id                   = aws_subnet.CGI_challenge_pub_subnet.id
#   ami                         = "ami-0df0e7600ad0913a9"
#   instance_type               = "t2.micro"
#   security_groups             = [aws_security_group.allow_ssh.id]
#   key_name                    = aws_key_pair.cgi_kind_key.key_name
#   iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
#   associate_public_ip_address = true


#   user_data = <<-EOF
#               #!/bin/bash
#               # Update packages and install docker
#               sudo yum update -y
#               sudo yum install -y docker
#               sudo service docker start
#               sudo usermod -aG docker ec2-user

#               # Install AWS CLI to authenticate with ECR
#               sudo yum install -y aws-cli

#               # Authenticate with ECR and pull image
#               $(aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 767828742018.dkr.ecr.eu-central-1.amazonaws.com)
#               docker pull 767828742018.dkr.ecr.eu-central-1.amazonaws.com/your-image:latest
#               docker run -d -p 80:80 767828742018.dkr.ecr.eu-central-1.amazonaws.com/your-image:latest
#               sudo yum update -y
#               EOF



#   tags = {
#     Name = "KinD-EC2"
#   }

# }
# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#   name = "ec2-instance-profile"
#   role = aws_iam_role.ec2_role.name
# }


# # Output the instance public IP
# output "instance_public_ip" {
#   value = aws_instance.cgi_kind_instance.public_ip
# }