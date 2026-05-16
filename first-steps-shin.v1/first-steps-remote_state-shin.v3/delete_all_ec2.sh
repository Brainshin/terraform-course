#!/bin/bash
# ==========================================================================
# [AWS EC2 일괄 삭제 자동화 프로그램]
# 지정된 리전 내의 모든 EC2 인스턴스를 조회하여 한 번에 안전하게 삭제합니다.
# ==========================================================================

# [설정] 인스턴스를 삭제할 AWS 리전을 지정합니다. (서울 리전 기본값)
TARGET_REGION="ap-northeast-2"

echo "--------------------------------------------------------"
echo "🔍 [1/3] ${TARGET_REGION} 리전에서 삭제 가능한 EC2 인스턴스를 조회 중..."
echo "--------------------------------------------------------"

# 1. 종료(Terminated) 상태가 아닌 모든 EC2의 인스턴스 ID 목록을 추출합니다.
INSTANCE_IDS=$(aws ec2 describe-instances \
    --region "${TARGET_REGION}" \
    --filters "Name=instance-state-name,Values=pending,running,shutting-down,stopping,stopped" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

# 2. 만약 조회된 서버가 하나도 없다면 프로그램을 즉시 종료합니다.
if [ -z "${INSTANCE_IDS}" ] || [ "${INSTANCE_IDS}" == "None" ]; then
    echo "✅ 삭제할 인스턴스가 존재하지 않습니다. 인프라가 깨끗합니다."
    echo "--------------------------------------------------------"
    exit 0
fi

# 3. 오작동 방지를 위해 삭제 대상 서버들의 ID 목록을 화면에 보여줍니다.
echo "📋 [삭제 대상 리스트]:"
echo "${INSTANCE_IDS}"
echo "--------------------------------------------------------"

# 4. 실수로 전체 인프라를 날리는 사고를 막기 위한 최종 수동 확인 절차
read -p "⚠️  정말로 위 목록의 모든 EC2 인스턴스를 삭제하시겠습니까? (yes/no): " CONFIRM
if [ "${CONFIRM}" != "yes" ]; then
    echo "❌ 작업이 사용자에 의해 취소되었습니다."
    echo "--------------------------------------------------------"
    exit 1
fi

echo "--------------------------------------------------------"
echo "🚀 [2/3] EC2 인스턴스 영구 철거 시작..."
echo "--------------------------------------------------------"

# 5. 추출된 ID 목록을 AWS CLI 주입하여 일괄 파괴 명령을 전송합니다.
aws ec2 terminate-instances \
    --region "${TARGET_REGION}" \
    --instance-ids ${INSTANCE_IDS} \
    --output table

echo "--------------------------------------------------------"
echo "⏳ [3/3] 서버가 완전히 삭제(Terminated)될 때까지 대기합니다..."
echo "--------------------------------------------------------"

# 6. AWS 인프라에서 완전히 철거 처리가 완료될 때까지 터미널을 붙잡고 대기(Wait)합니다.
aws ec2 wait instance-terminated \
    --region "${TARGET_REGION}" \
    --instance-ids ${INSTANCE_IDS}

echo "🎉 모든 EC2 인스턴스가 성공적으로 철거되었습니다!"
echo "--------------------------------------------------------"

