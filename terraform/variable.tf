// 東京リージョンに設定
provider "aws" {
  region = "ap-northeast-1"
}

// terraform-fargate-appというバケットに状態(tf.state)を保存
terraform {
  backend "s3" {
    bucket = "terraform-fargate-app"
    key = "fargate-app.tfstate"
    region = "ap-northeast-1"
    profile = "terraform"
  }
}

// aws configureで設定したIAMユーザー名
variable aws_profile {
  default = "terraform"
}

// vpcの設定で使用
variable "region" {
  default = "ap-northeast-1"
}

// vpcの命名で使用
variable "category" {
  default = "example"
}

// ECS・ECR・ALB等の命名で使用
variable "task_name" {
  default = "fargate"
}

// 命名に使用。環境を識別するための変数
variable "env" {
  default = "staging"
}
