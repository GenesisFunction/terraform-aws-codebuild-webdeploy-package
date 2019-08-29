# codebuild-webdeploy-package
codebuild-webdeploy-package is used to make a codebuild which will create a web deploy package for a .net application.

NOTE: If using a private repo, you need to manually set up authentication (and currently webhooks too).

### To-Do
- Add for-each environment variable interpolation?
- Add webhook

### Example Usage:
Create a cluster with a single service, mapped to a single task, which has a single container:
```
module "codebuild_webdeploy_app_name" {
  source  = "GenesisFunction/codebuild-webdeploy-package/aws"
  version = "1.0.1"
  #source  = "github.com/GenesisFunction/terraform-aws-codebuild-webdeploy-package"
  
  codebuild_name         = "app-name"
  codebuild_description  = "app-name"
  source_type            = "BITBUCKET"
  source_location        = "https://bitbucket.org/company/app-name.git"
  artifact_name          = "app-name"
  artifact_s3_bucket_id  = aws_s3_bucket.codebuild_artifacts.id
  artifact_s3_bucket_arn = aws_s3_bucket.codebuild_artifacts.arn
  container_image        = "mcr.microsoft.com/dotnet/framework/sdk:4.8" # <- dockerhub container that has MS SDK already
  compute_type           = "BUILD_GENERAL1_MEDIUM"
  build_timeout          = 30
  build_configuration    = "Release"
  input_tags             = local.common_tags
}

```
