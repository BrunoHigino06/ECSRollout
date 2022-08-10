#Role to enable Main account to access the ECS on another account
resource "aws_iam_role" "Lambda_access" {
  name = var.Lambda_access.name

  assume_role_policy = file("./iam/json/${var.Lambda_access.jsonfile_name}")
  tags = {
    name = var.Lambda_access.name
  }
}

resource "aws_iam_role_policy_attachment" "ECSFullAccess" {
  role       = aws_iam_role.Lambda_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}