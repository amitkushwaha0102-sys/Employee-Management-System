data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "employee-mgmt-key"
  public_key = file("~/.ssh/employee-mgmt-key2.pub")
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_app_a.id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = aws_key_pair.deployer.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name
  user_data              = file("scripts/user-data.sh")

  tags = {
    Name = "employee-mgmt-app-server"
  }
}