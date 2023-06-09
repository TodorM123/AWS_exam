#################### launch-template #####################

resource "aws_launch_template" "first_template" {
  name_prefix            = var.instance_data.name-prefix
  image_id               = data.aws_ami.latest_amazon_linux.image_id
  instance_type          = var.instance_data.instance_type
  update_default_version = true
  tag_specifications {}
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.iam_instance_profile.name
  }
    tags = {
      key = "Name"
      value = "Instanciika"
      propagate_at_launch = true
    }
  user_data = base64encode(
    <<-EOF
    #!/bin/bash
    amazon-linux-extras install -y nginx1
    systemctl enable nginx --now
    EOF
  )
}

