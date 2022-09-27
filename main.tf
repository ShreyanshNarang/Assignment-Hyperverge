resource "aws_instance" "ec2_instance" {
  ami             = "ami-05c8ca4485f8b138a"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.devops_SG.name]
  key_name        = "key-tf"
  user_data       = file("script.sh")
  tags = {
    Name = "devops-tf"
  }
}
