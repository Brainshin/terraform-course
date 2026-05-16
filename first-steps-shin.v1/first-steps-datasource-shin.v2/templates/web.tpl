#!/bin/bash
# ==========================================================================
# [EC2 초기화 부팅 스크립트] 
# 가상 서버가 최초로 구동될 때 root 권한으로 자동 실행되는 무대 세팅용 스크립트입니다.
# ==========================================================================

# 1. 우분투 패키지 설치 주소록(Repository)을 최신 상태로 업데이트합니다.
# 이 과정을 거쳐야 뒤이어 설치할 패키지들을 인터넷 공간에서 정상적으로 찾아냅니다.
apt-get update -y

# 2. [오류 수정] 하이픈(-)을 제거한 올바른 규격인 'awscli'를 설치합니다.
# 이전 'aws-cli' 오타로 인해 전체 스크립트가 다운되던 문제를 완벽히 해결했습니다.
apt-get install -y awscli

# 3. [웹 서버 추가] Nginx 웹 서버 패키지를 무인(설치 동의) 모드로 자동 설치합니다.
# 앞선 명령어가 정상 통과되므로 이제 이 단계까지 막힘없이 실행됩니다.
apt-get install -y nginx

# 4. 부팅 시 Nginx가 자동으로 켜지도록 시스템에 등록하고, 즉시 구동을 시작합니다.
systemctl enable nginx
systemctl start nginx

# 5. [선택 사항] Nginx의 기본 화면을 구별하기 쉽도록 커스텀 안내 텍스트로 교체합니다.
# 테라폼 변수(var.aws_region)를 통해 주입받은 리전 이름이 화면에 표기됩니다.
echo "<h1>Welcome! This server is running in AWS Region: ${region}</h1>" > /var/www/html/index.html

rm /var/www/html/index.nginx-debian.html 
aws s3 sync s3://${bucket_name} /var/www/html