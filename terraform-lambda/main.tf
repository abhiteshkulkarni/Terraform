provider "aws" {

region = "ap-south-1"

}

resource "aws_iam_role" "lambda_exec_role" {

name = "lambda_exec_role"

assume_role_policy = jsonencode ({

version = "2012-10-17",

statement = [{

Action = "sts:AssumeRole",
Effect = "Allow"
principle = {

service = "lambda.amazonaws.com"

}

}]
})

}


resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {

role = aws_iam_role.lambda_exec_role.name

policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}


resource "aws_lambda_function" "myLambda" {

function_name = "myLambdaFunction"
filename = "function.zip"
handler = "lambda_function.lambda_handler"
runtime = "python3.9"

source_code_hash = filebase64sha256("function.zip")
role = aws_iam_role.lambda_exec_role.arn

}
