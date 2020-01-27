data "template_file" "command" {
  template = file("${path.module}/templates/task_definition_command.json")

  vars = {
    image_web             = format("%s:latest", aws_ecr_repository.web.repository_url)
    image_nginx           = format("%s:latest", aws_ecr_repository.nginx.repository_url)
    awslogs_group         = aws_cloudwatch_log_group.web.name
    database_url          = format("postgres://%s:%s@%s/%s", var.db_user, var.db_password, var.db_endpoint, var.db_dbname)
    rails_env             = var.rails_env
    bugsnag_api_key       = aws_ssm_parameter.app_bugsnag_api_key.value
    mail_host             = var.mail_host
    mail_from_domain      = var.ses_domain
    frontend_host         = format("https://%s", var.domain)
    facebook_key          = aws_ssm_parameter.app_facebook_key.value
    facebook_secret       = aws_ssm_parameter.app_facebook_secret.value
    aws_access_key_id     = aws_iam_access_key.web.id
    aws_secret_access_key = aws_iam_access_key.web.secret
    aws_region            = "ap-northeast-1"
    bucket_name           = var.domain
    nginx_environment     = var.nginx_environment
  }
}

resource "aws_ecs_task_definition" "command" {
  family                   = "${var.name}-command"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = var.cpu
  memory = var.memory

  task_role_arn         = aws_iam_role.ecs_task.arn
  execution_role_arn    = aws_iam_role.ecs_task_execution.arn
  container_definitions = data.template_file.command.rendered

  tags = merge(var.common_tags, { Name = format("%s-ecs-task-db-command", var.name) })
}
