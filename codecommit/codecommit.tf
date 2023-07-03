// CodeCommit Repository
resource "aws_codecommit_repository" "codecommit_repository" {
  repository_name = var.repository_name
  description     = var.description
  default_branch  = var.default_branch
}

// Null Resource to prevent creating empty repository
resource "null_resource" "codecommit_interaction" {
  depends_on = [aws_codecommit_repository.codecommit_repository]

  triggers = {
    run_on_creation = timestamp()
  }

  // Base64 encoded value...
  provisioner "local-exec" {
    command = <<EOT
    aws codecommit create-commit --repository-name ${aws_codecommit_repository.codecommit_repository.repository_name} --branch-name ${var.default_branch} --put-files "filePath=README.md,fileContent=QnJhbmNoIFByb3RlY3RlZCBSZXBvc2l0b3J5"
    EOT
  }

  lifecycle {
    ignore_changes = [
      triggers
    ]
  }
}
