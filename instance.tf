data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["${var.image_name}"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name
  vpc_security_group_ids = ["${aws_security_group.sg-tf.id}"]

  tags = {
    Name = "first-tf-instance"
  }
  user_data = file("${path.module}/nginx.sh")

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/id_rsa")

  }


  #   provisioner "file" {
  #     source =   "readme.md"
  #     destination = "/tmp/readme.md"


  #   }


  #     provisioner "file" {
  #     content =     "heelooo"
  #     destination = "/tmp/content.md"

  # }

  #     provisioner "local-exec" {
  #         working_dir = "/tmp"
  #         command = "echo ${self.public_ip} > mypublicip.txt"


  # }

  #     provisioner "local-exec" {
  #  when = destroy

  #         interpreter = [ 
  #             "/usr/bin/python3" , "-c"
  #          ]
  #         command = "print('hello world')"


  # }

  provisioner "remote-exec" {
    inline = [
      "ifconfig > /tmp/ifconfig.output",
      "echo 'hello akshaya'>/tmp/test.txt"
    ]
  }

  provisioner "remote-exec" {
    script = "./test_script.sh"
  }

}