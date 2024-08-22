terraform {
  cloud {
    organization = "jergauth-terraform-playground"

    workspaces {
      name = "learn-terraform-github-actions"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-3"
}

# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "lambda_role" {
#   name               = "my-first-tf-lambda-role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

# resource "aws_iam_role_policy" "lambda" {
#   name = "lambda-permissions"
#   role = aws_iam_role.lambda_role.name
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents",
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

# data "archive_file" "hello_world_lambda" {
#   type        = "zip"
#   source_file = "lambdas/hello.js"
#   output_path = "hello.zip"
# }

# resource "aws_lambda_function" "lambda" {
#   filename      = data.archive_file.hello_world_lambda.output_path
#   function_name = "my-first-tf-lambda-function"
#   role          = aws_iam_role.lambda_role.arn
#   handler       = "hello.handler"

#   source_code_hash = data.archive_file.hello_world_lambda.output_base64sha256

#   runtime = "nodejs18.x"
# }

# resource "aws_instance" "terraform2_example_app_server" {
#   ami           = "ami-0e141aee2812422a2"
#   instance_type = "t2.micro"

#   tags = {
#     Name = var.instance_name
#   }
# }

# output "instance_id" {
#   description = "ID of the EC2 instance"
#   value       = aws_instance.terraform2_example_app_server.id
# }

# output "instance_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.terraform2_example_app_server.public_ip
# }
