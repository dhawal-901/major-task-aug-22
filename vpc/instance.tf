# resource "aws_key_pair" "my_public_instance_key" {
#   key_name   = "my_public_instance_key"
#   public_key = file("../keys/bastion.pub")
# }

# resource "aws_key_pair" "my_private_instance_key" {
#   key_name   = "my_private_instance_key"
#   public_key = file("../keys/private-1.pub")
# }
data "aws_key_pair" "my_public_instance_key" {
  key_name = "my_public_instance_key"
}

data "aws_key_pair" "my_private_instance_key" {
  key_name = "my_private_instance_key"
}


resource "aws_instance" "my_public_instance" {
  count                       = 1
  ami                         = local.Environment.public_instance_ami
  instance_type               = local.Environment.public_instance_type
  subnet_id                   = module.vpc.public_subnets[(count.index) % 2]
  vpc_security_group_ids      = [aws_security_group.my_public_sg.id]
  key_name                    = data.aws_key_pair.my_public_instance_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "PUBLIC_INSTANCE_TF_${terraform.workspace}"
  }
  depends_on = [module.vpc, data.aws_key_pair.my_public_instance_key]
}

resource "aws_instance" "my_private_instance" {
  count                  = 1
  ami                    = local.Environment.private_instance_ami
  instance_type          = local.Environment.private_instance_type
  subnet_id              = module.vpc.private_subnets[(count.index) % 2]
  vpc_security_group_ids = [aws_security_group.my_private_sg.id, aws_security_group.my_public_sg.id]
  key_name               = data.aws_key_pair.my_private_instance_key.key_name
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "PRIVATE_INSTANCE_TF_${count.index + 1}_${terraform.workspace}"
  }
  depends_on = [module.vpc, data.aws_key_pair.my_private_instance_key]
}
