# ==========================================================================
# [AWS VPC 네트워크 구성]
# 공식 테라폼 AWS VPC 모듈을 사용하여 가상 네트워크 환경을 자동 구축합니다.
# ==========================================================================
module "vpc" {
  # 사용할 외부 공식 모듈의 주소와 버전 정의
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" # 최신 버전의 안정적인 사용을 위해 버전 명시 권장

  # 생성될 가상 네트워크(VPC)의 이름 설정
  name = "my-vpc"

  # VPC 가 사용할 전체 IP 대역폭 정의 (총 65,536개 IP 확보)
  cidr = "10.0.0.0/16"

  # [수정] 가용 영역(AZ) 지정 구문 최적화 (서울 리전: ap-northeast-2)
  # 이전의 "${var.aws_region}a" 형태의 불필요한 문자열 보간 문법을 간결하게 변경했습니다.
  azs = [
    "${var.aws_region}a", # 서울 리전 가용영역 A (ap-northeast-2a)
    "${var.aws_region}b", # 서울 리전 가용영역 B (ap-northeast-2b)
    "${var.aws_region}c"  # 서울 리전 가용영역 C (ap-northeast-2c)
  ]

  # 내부 서버 전용 사설(Private) 서브넷 대역 (인터넷에서 직접 접근 불가)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  # 외부 노출용 공인(Public) 서브넷 대역 (인터넷 게이트웨이와 연결됨)
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # 이 공인 서브넷에 배치되는 자원(예: EC2)에 퍼블릭 IP를 자동으로 부여합니다.
  # 앞서 질문하신 EC2 인스턴스의 public_ip가 비어있던 문제를 이 옵션이 해결해 줍니다.
  map_public_ip_on_launch = true

  # 비용 절감을 위해 인터넷 나가는 문(NAT 게이트웨이)과 VPN 게이트웨이를 생성하지 않습니다.
  enable_nat_gateway = false
  enable_vpn_gateway = false

  # 자원 관리 및 비용 추적을 위한 공통 태그 부여
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
