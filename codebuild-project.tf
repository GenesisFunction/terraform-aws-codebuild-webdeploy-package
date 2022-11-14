# This applies, but needs MANUAL OAUTH integration #
# Add OAUTH Build Projects > Project > Edit Source > Connect to ... #
# You don't need to hit save, the connection will stay even if you discard your changes! #

# Windows Images only support .net core by default.
# Custom image creation here: https://aws.amazon.com/blogs/devops/extending-aws-codebuild-with-custom-build-environments-for-the-net-framework/
# Example for using MS Docker Image here: https://stackoverflow.com/a/53699063
resource "aws_iam_role" "iam_role" {
  name = "${var.codebuild_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = var.input_tags
}

resource "aws_iam_role_policy" "iam_role_policy" {
  role = aws_iam_role.iam_role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudWatchLogsWriting",
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Sid": "AllowToArtifactBucket",
      "Effect": "Allow",
      "Action": [
        "s3:List*",
        "s3:Get*",
        "s3:PutObject",
        "s3:AbortMultipartUpload"
      ],
      "Resource": [
        "${var.artifact_s3_bucket_arn}",
        "${var.artifact_s3_bucket_arn}/*"
      ]
    }
  ]
}
POLICY

}

resource "aws_codebuild_project" "project" {
  name          = var.codebuild_name
  description   = var.codebuild_description
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.iam_role.arn

  artifacts {
    type      = "S3"
    location  = var.artifact_s3_bucket_id # <- S3 bucket to place artifacts into
    packaging = "NONE"                    # <- Don't zip artifacts (output of WebDeploy is a zip file)
    name      = var.codebuild_name        # <- name of zip file in bucket
  }

  environment {
    compute_type = var.compute_type

    image = var.container_image
    type  = "WINDOWS_CONTAINER"

    image_pull_credentials_type = "SERVICE_ROLE"
  }

  source {
    type     = var.source_type
    location = var.source_location

    git_clone_depth     = var.git_clone_depth
    insecure_ssl        = false
    report_build_status = false

    buildspec = <<BUILDSPEC
version: 0.2

# env:
#   variables:

phases:
  build:
    commands:
      - nuget restore
      - ${local.build_command}
      - ls -Recurse "C:\${var.artifact_path}"
artifacts:
  files:
    - '\${var.artifact_path}\*.zip'
BUILDSPEC

  }

  tags = var.input_tags
}

