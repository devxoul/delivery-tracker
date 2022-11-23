# Delivery Tracker

https://github.com/shlee322/delivery-tracker 코드를 Fork 하여 작성한 저장소입니다.

## 배포하기

### dev

main 브랜치에 새로운 커밋이 푸시될 때마다 자동으로 Terraform에 의해 ECS로 배포됩니다.

### prod

[CD 워크플로우](https://github.com/indentcorp/delivery-tracker/actions/workflows/cd.yml)에서 수동으로 Run workflow 기능을 사용하여 배포할 커밋 SHA를 특정하여 배포합니다. 워크플로우를 트리거하면 Terraform에 의해 ECS로 배포됩니다.
