data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "my-first-tf-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "lambda" {
  name = "lambda-permissions"
  role = aws_iam_role.lambda_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "archive_file" "lambda" {
  for_each    = fileset("lambdas", "*.js")
  type        = "zip"
  source_file = "../src/lambdas/${basename(each.value)}"
  output_path = "${replace(basename(each.value), ".js", "")}.zip"
}

resource "aws_lambda_function" "lambda" {
  for_each      = data.archive_file.lambda
  filename      = data.archive_file.lambda[each.key].output_path
  function_name = replace(data.archive_file.lambda[each.key].output_path, ".zip", "")
  role          = aws_iam_role.lambda_role.arn
  handler       = "${replace(data.archive_file.lambda[each.key].output_path, ".zip", "")}.handler"

  source_code_hash = data.archive_file.lambda[each.key].output_base64sha256

  runtime = "nodejs18.x"
}

