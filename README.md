# push image to ECR

```bash
$(aws ecr get-login --no-include-email --region ap-northeast-1)
cd terraform
terraform init
terraform apply --target=aws_ecr_repository.frontend
terraform apply --target=aws_ecr_repository.backend
cd docker
./build.sh frontend
./build.sh backend
```

# register task definition

```bash
cd deploy/frontend
aws ecs register-task-definition --cli-input-json file://task-definition.json
cd deploy/backend
aws ecs register-task-definition --cli-input-json file://task-definition.json
```

# terraform apply

```bash
terraform apply 
```

# operation verification
1. copy alb dns name
2. access dns by browser

# deploy by espresso

```bash
cd deploy/frontend
ecspresso deploy --config config.yaml
cd deploy/backend
ecspresso deploy --config config.yaml
```

