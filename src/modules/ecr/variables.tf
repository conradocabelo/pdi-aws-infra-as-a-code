resource "aws_ecr_repository" "ecr_repository" {
  for_each = toset(var.ecr_repositories)
  name     = lower("${each.key}")
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_repository_policy" {
  for_each   = toset(var.ecr_repositories)
  repository = lower("${each.key}")
  depends_on = [aws_ecr_repository.ecr_repository]
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 7 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 7
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

output "repository" {
  value = aws_ecr_repository.ecr_repository
}