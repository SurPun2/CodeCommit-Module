// IAM Group
resource "aws_iam_group" "developers" {
  name = var.group_name
}

// Custom Deny Policy For Branch Protection
resource "aws_iam_policy" "branch_policy" {
  name        = "DenyChangesToMain"
  path        = "/"
  description = "Branch Protection Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Deny",
        "Action" : [
          "codecommit:GitPush",
          "codecommit:DeleteBranch",
          "codecommit:PutFile",
        ],
        "Resource" : "${aws_codecommit_repository.codecommit_repository.arn}",
        "Condition" : {
          "StringEqualsIfExists" : {
            "codecommit:References" : [
              "refs/heads/main",
            ]
          },
          "Null" : {
            "codecommit:References" : "false"
          }
        }
      }
    ]
  })
}

// Attach Deny Policy to IAM Group
resource "aws_iam_group_policy_attachment" "restrict" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.branch_policy.arn
}

// IAM User
resource "aws_iam_user" "user" {
  for_each = toset(var.user_name)

  name          = each.value
  path          = "/"
  force_destroy = true

  tags = {
    tag-key = var.group_name
  }
}

// Add User to IAM Group
resource "aws_iam_group_membership" "user" {
  for_each = toset(var.user_name)

  name  = each.value
  users = [aws_iam_user.user[each.key].name]
  group = var.group_name
}

// Custom Least Privilege Policy
resource "aws_iam_policy" "least_policy" {
  name        = "CodeCommitPolicy"
  path        = "/"
  description = "Policy for CodeCommit repository access"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "codecommit:GetRepository",
          "codecommit:ListRepositories",
          "codecommit:GetFolder",
          "codecommit:GetCommit",
          "codecommit:GetCommitHistory",
          "codecommit:GitPull",
          "codecommit:GitClone",
          "codecommit:GitPush",
          "codecommit:CreateBranch",
          "codecommit:CreatePullRequest",
          "codecommit:ListPullRequests",
          "codecommit:GetCommentsForPullRequest",
          "codecommit:GetCommitsFromMergeBase",
          "codecommit:BatchGetPullRequests",
          "codecommit:GetPullRequest",
          "codecommit:GetPullRequestApprovalStates",
          "codecommit:GetMergeOptions",
          "codecommit:MergePullRequestByFastForward",
          "codecommit:DeleteBranch",
          "codecommit:DescribePullRequestEvents",
          "codecommit:EvaluatePullRequestApprovalRules",
          "codecommit:ListApprovalRuleTemplates",
          "codecommit:GetRepositoryTriggers",
          "codecommit:GetBlob",
          "codecommit:GetTree",
          "codecommit:GetReferences",
          "codecommit:GetDifferences",
          "codecommit:GetObjectIdentifier",
          "codestar-notifications:ListNotificationRules",
          "codecommit:ListTagsForResource",
          # "codebuild:ListProjects",
        ],
        "Resource" : "*"
      }
    ]
  })
}

// Attach Least Privilege Policy to IAM User
resource "aws_iam_user_policy_attachment" "attachment" {
  for_each = toset(var.user_name)

  user       = aws_iam_user.user[each.key].name
  policy_arn = aws_iam_policy.least_policy.arn
}
