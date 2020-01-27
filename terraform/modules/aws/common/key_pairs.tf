resource "aws_key_pair" "app" {
  key_name   = var.name
  public_key = file(var.key_pair_file_path)
}
