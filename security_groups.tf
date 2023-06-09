# SECURITY GROUPS #
# Nginx(EC2) security group 
resource "aws_security_group" "nginx_sg" {
  name   = "nginx-sg"
  vpc_id = aws_vpc.main.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SECURITY GROUPS #
# LB security group 
resource "aws_security_group" "alb_sg" {
  name   = "nginx-alb-sg"
  vpc_id = aws_vpc.main.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["91.211.97.132/32"] ##### ILI access ot vsqkude (0.0.0.0/0)
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

