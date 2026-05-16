# ==========================================================================
# [데이터 소스] AWS에서 가장 최신의 공식 Ubuntu AMI 정보를 조회
# ==========================================================================
data "aws_ami" "ubuntu" {
  most_recent = true

  # 첫 번째 필터: 이미지 이름 조건
  filter {
    name   = "name" 
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }

  # [수정 위치] 두 번째 필터: 가상화 타입 조건
  # 기존에 "virualization-type"으로 적힌 부분을 "virtualization-type"으로 고칩니다.
  filter {
    name   = "virtualization-type" # ◀ 여기에 알파벳 't'를 추가해 주세요 (vi-r-t-u-alization)
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}
