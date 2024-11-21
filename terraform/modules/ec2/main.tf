# modules/ec2/main.tf
resource "aws_instance" "data_transfer" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  iam_instance_profile = aws_iam_instance_profile.data_transfer_profile.name

  tags = {
    Name = "${var.project_name}-data-transfer"
    Environment = var.environment
  }

  user_data = templatefile("${path.module}/../../scripts/airflow_setup.sh", {
    region = var.aws_region
  })

  vpc_security_group_ids = [aws_security_group.data_transfer_sg.id]
}

resource "aws_iam_instance_profile" "data_transfer_profile" {
  name = "${var.project_name}-ec2-profile"
  role = var.ec2_role_name
}

resource "aws_security_group" "data_transfer_sg" {
  name        = "${var.project_name}-data-transfer-sg"
  description = "Security group for data transfer EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP/32"]  # Replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

