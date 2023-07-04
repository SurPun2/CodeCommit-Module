# CodeCommit Module Documentation

This CodeCommit module is designed to create an AWS CodeCommit repository and configure associated resources such as IAM groups and users. This documentation will guide you through the steps to run this module effectively.

## Module Purpose and Benefits

Modules in Terraform are used to create reusable and modular code that can be easily shared and reused across different projects. They help in organising and encapsulating configurations, reducing duplication, and ensuring consistency and best practices. By using modules, you can:

- Organise and navigate configuration files more easily
- Encapsulate configuration into logical components
- Reuse configuration and save time
- Provide consistency and ensure best practices
- Enable self-service provisioning for other teams

## Usage

Include this repository as a module in your existing Terraform code:
```
module "codecommit_repository" {
  source = "github.com/SurPun2/CodeCommit-Module"

  repository_name = "X-APP"
  description     = "Zaizi's Desk Booking App Repository"
  default_branch  = "main"

  # Creates an Iam Group with Branch Protection Policy
  group_name = "Developers"

  # Creates users with least privilege policy attached to them
  user_name     = ["Dev1", "Dev2", "Dev3"]
  path          = "/"
  force_destroy = true

  # Tags
  tags = "X-App"
}
```

or


```
module "codecommit_repository" {
  source = "../modules/codecommit"

  repository_name = "X-APP"
  description = "Zaizi's Desk Booking App Repository"
  default_branch = "main"

  group_name = "Developers"
  user_name = ["Dev1", "Dev2", "Dev3"]
  path = "/"
  force_destroy = true
}
```

## Resources

| Name                                            | Description                           |
| ----------------------------------------------- | ------------------------------------- |
| aws_codecommit_repository.codecommit_repository | Codecommit Repository                 |
| aws_iam_group.developers                        | IAM Group                             |
| aws_iam_policy.branch_policy                    | IAM Policy (For IAM Group)            |
| aws_iam_group_policy_attachment.restrict        | IAM Policy Attachment (For IAM Group) |
| aws_iam_user.user                               | IAM User                              |
| aws_iam_group_membership.user                   | IAM Group Membership                  |
| aws_iam_policy.least_policy                     | IAM Policy (For IAM User)             |
| aws_iam_user_policy_attachment.attachment       | IAM Policy Attachment (For IAM User)  |

## InPuts

| Name            | Description                                                  | Type   | Default |
| --------------- | ------------------------------------------------------------ | ------ | ------- |
| Name            | Description                                                  | Type   | Default |
| repository_name | The name of the CodeCommit Repository                        | string | n/a     |
| description     | A description of the CodeCommit Repository                   | string | ""      |
| default_branch  | The name of the default repository branch                    | string | "main"  |
| group_name      | The name of the IAM Group                                    | string | n/a     |
| user_name       | The name of the IAM User                                     | string | n/a     |
| path            | The path of the IAM user                                     | string | n/a     |
| force_destroy   | Whether to destroy the IAM user when the module is destroyed | bool   | n/a     |

## OutPuts

| Name            | Description                          |
| --------------- | ------------------------------------ |
| repository_url  | CodeCommit Repository URL            |
| repository_name | CodeCommit Repository Name           |
| default_branch  | CodeCommit Repository Default Branch |
| arn             | CodeCommit Repository ARN            |
| group_name      | IAM Group Name                       |

## Running the CodeCommit Module

To run the CodeCommit Module, follow these steps:

- Step 1: Configure the Module

  - Ensure that you have the necessary permissions to create resources in AWS CodeCommit
  - Open the Terraform configuration file where you want to use the module
  - Add the following code block to configure the module
  - Customize the configuration according to your requirements.
  - Save the configuration file.

- Step 2: Verify the Resources

  - Initialize the terraform Configuration 
    `terraform init`

  - Preview the Changes
    `terraform plan`

  - Apply the Changes
    `terraform apply`

  - Verify the Resources, Once the provisioning process is complete, you can verify the creation of the CodeCommit repository and associated resources in the AWS Management Console.

- Step 3: IAM User Management

    - Once the Resources are successfully created, navigate to AWS Console => IAM Management => Users.
    - The Users should now have a direct policy and an inherit policy attached to it belonging from the developers group.
    - Inside the User, navigate to the security credentials tab, we will then need to enable the console sign-in so that our developers can review the repository and create pull requests.
    - We can now provide the console sign-in URL, User name and Console password for our developers working in the team.
    - We will also need to create the Access key and HTTPS Git credentials for AWS CodeCommit.