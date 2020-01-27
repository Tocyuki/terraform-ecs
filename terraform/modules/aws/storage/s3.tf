data "template_file" "main" {
  template = file("${path.module}/templates/bucket_policy.json")

  vars = {
    bucket_name = var.bucket_name
  }
}

resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = merge(var.common_tags, { Name = format("%s-s3", var.name) })
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.template_file.main.rendered
}
