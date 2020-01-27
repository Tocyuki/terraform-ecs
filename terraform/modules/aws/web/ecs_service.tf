data "template_file" "web" {
  template = file("${path.module}/templates/task_definition.json")

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

resource "aws_ecs_task_definition" "web" {
  family                   = "${var.name}-web"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = var.cpu
  memory = var.memory

  task_role_arn         = aws_iam_role.ecs_task.arn
  execution_role_arn    = aws_iam_role.ecs_task_execution.arn
  container_definitions = data.template_file.web.rendered

  tags = merge(var.common_tags, { Name = format("%s-ecs-task-web", var.name) })
}

resource "aws_ecs_service" "web" {
  name            = "web"
  cluster         = var.ecs_cluster.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = var.service_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.web.id]
    subnets         = var.private_subnets[*].id
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.web.arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [
    "aws_alb_listener.http",
    "aws_alb_listener.https"
  ]
}

resource "aws_appautoscaling_target" "web" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster.name}/${aws_ecs_service.web.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.autoscaling_min_capacity
  max_capacity       = var.autoscaling_max_capacity
}

resource "aws_appautoscaling_policy" "web_cpu" {
  name        = "${var.name}-web-scale-cpu"
  policy_type = "TargetTrackingScaling"

  resource_id        = aws_appautoscaling_target.web.resource_id
  scalable_dimension = aws_appautoscaling_target.web.scalable_dimension
  service_namespace  = aws_appautoscaling_target.web.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "web_memory" {
  name        = "${var.name}-web-scale-memory"
  policy_type = "TargetTrackingScaling"

  resource_id        = aws_appautoscaling_target.web.resource_id
  scalable_dimension = aws_appautoscaling_target.web.scalable_dimension
  service_namespace  = aws_appautoscaling_target.web.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
