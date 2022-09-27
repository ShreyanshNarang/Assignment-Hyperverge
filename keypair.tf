resource "aws_key_pair" "key_tf" {
  key_name   = "key-tf"
  public_key = file("${path.module}/keypair.pub")
}
