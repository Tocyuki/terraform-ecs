data "template_file" "role_ecs_task" {
  template = "${file("${path.module}/templates/iam_role_ecs_task.json")}"
}

resource "aws_iam_role" "ecs_task" {
  name               = "${var.name}-web-task"
  assume_role_policy = data.template_file.role_ecs_task.rendered
}

data "template_file" "role_ecs_task_execution" {
  template = "${file("${path.module}/templates/iam_role_ecs_task_execution.json")}"
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.name}-web-task-execution"
  assume_role_policy = data.template_file.role_ecs_task_execution.rendered
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_user" "web" {
  name = "${var.name}-web"

  tags = merge(var.common_tags, { Name = format("%s-iam-web", var.name) })
}

data "template_file" "user_policy_web" {
  template = "${file("${path.module}/templates/iam_user_policy_web.json")}"

  vars = {
    bucket_arn = var.bucket.arn
  }
}

resource "aws_iam_user_policy" "web" {
  user   = aws_iam_user.web.name
  name   = "app"
  policy = data.template_file.user_policy_web.rendered
}

resource "aws_iam_access_key" "web" {
  user = aws_iam_user.web.name
}
