
provider "aws" {
  region = "ap-northeast-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t4g.micro"
  tags = {
    Name = "aws-ec2-server"
  }
}

# 최종 설치 확인 
# ws ec2 describe-instances --query "Reservations[*].Instances[*].{ID:InstanceId,State:State.Name,Name:Tags[?Key=='Name'].Value | [0]}" --output table