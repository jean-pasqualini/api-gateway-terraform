resource "aws_api_gateway_rest_api" "rest_api_terraform_mode" {
  name = "rest-api-terraform-mode"
}

resource "aws_api_gateway_resource" "rest_api_terraform_mode_first_level" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_terraform_mode.id
  parent_id   = aws_api_gateway_rest_api.rest_api_terraform_mode.root_resource_id
  path_part   = "first_level"
}

resource "aws_api_gateway_resource" "rest_api_terraform_mode_second_level" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_terraform_mode.id
  parent_id   = aws_api_gateway_resource.rest_api_terraform_mode_first_level.id
  path_part   = "second_level"
}

resource "aws_api_gateway_method" "rest_api_terraform_mode_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api_terraform_mode.id
  resource_id   = aws_api_gateway_resource.rest_api_terraform_mode_second_level.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "rest_api_terraform_mode_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_terraform_mode.id
  resource_id = aws_api_gateway_resource.rest_api_terraform_mode_second_level.id
  http_method = aws_api_gateway_method.rest_api_terraform_mode_get_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = <<EOF
    $input.json('$')
    EOF
  }
}

resource "aws_api_gateway_method" "rest_api_terraform_mode_delete_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api_terraform_mode.id
  resource_id   = aws_api_gateway_resource.rest_api_terraform_mode_second_level.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "rest_api_terraform_mode_delete_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_terraform_mode.id
  resource_id = aws_api_gateway_resource.rest_api_terraform_mode_second_level.id
  http_method = aws_api_gateway_method.rest_api_terraform_mode_delete_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = <<EOF
    $input.json('$')
    EOF
  }
}

resource "aws_api_gateway_deployment" "rest_api_terraform_mode_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_terraform_mode.id
  stage_name = "current"

  depends_on = [
    aws_api_gateway_integration.rest_api_terraform_mode_get_integration,
    aws_api_gateway_integration.rest_api_terraform_mode_delete_integration
  ]

  description       = "Deployed at ${timestamp()}"
  stage_description = "Deployed at ${timestamp()}"

  lifecycle {
    create_before_destroy = true
  }

  variables = {
    deployed_at = "Deployed at ${timestamp()}"
  }
}