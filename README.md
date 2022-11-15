<!-- BEGIN_TF_DOCS -->
# terraform-aws-codebuild-webdeploy-package
GitHub: [StratusGrid/terraform-aws-codebuild-webdeploy-package](https://github.com/StratusGrid/terraform-aws-codebuild-webdeploy-package)

codebuild-webdeploy-package is used to make a codebuild which will create a web deploy package for a .net application.

NOTE: If using a private repo, you need to manually set up authentication (and currently webhooks too).

### To-Do
- Add for-each environment variable interpolation?
- Add webhook

## Example
```hcl
Create a cluster with a single service, mapped to a single task, which has a single container:
```
module "codebuild_webdeploy_app_name" {
  source  = "GenesisFunction/codebuild-webdeploy-package/aws"
  version = "1.0.2"
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
## StratusGrid Standards we assume
- All resource names and name tags shall use `_` and not `-`s
- The old naming standard for common files such as inputs, outputs, providers, etc was to prefix them with a `-`, this is no longer true as it's not POSIX compliant. Our pre-commit hooks will fail with this old standard.
- StratusGrid generally follows the TerraForm standards outlined [here](https://www.terraform-best-practices.com/naming)
## Repo Knowledge
Repository for Module vmimport
## Documentation
This repo is self documenting via Terraform Docs, please see the note at the bottom.
### `LICENSE`
This is the standard Apache 2.0 License as defined [here](https://stratusgrid.atlassian.net/wiki/spaces/TK/pages/2121728017/StratusGrid+Terraform+Module+Requirements).
### `outputs.tf`
The StratusGrid standard for Terraform Outputs.
### `README.md`
It's this file! I'm always updated via TF Docs!
### `tags.tf`
The StratusGrid standard for provider/module level tagging. This file contains logic to always merge the repo URL.
### `variables.tf`
All variables related to this repo for all facets.
One day this should be broken up into each file, maybe maybe not.
### `versions.tf`
This file contains the required providers and their versions. Providers need to be specified otherwise provider overrides can not be done.
## Documentation of Misc Config Files
This section is supposed to outline what the misc configuration files do and what is there purpose
### `.config/.terraform-docs.yml`
This file auto generates your `README.md` file.
### `.github/workflows/pre-commit.yml`
This file contains the instructions for Github workflows, in specific this file run pre-commit and will allow the PR to pass or fail. This is a safety check and extras for if pre-commit isn't run locally.
### `examples/*`
The files in here are used by `.config/terraform-docs.yml` for generating the `README.md`. All files must end in `.tfnot` so Terraform validate doesn't trip on them since they're purely example files.
### `.gitignore`
This is your gitignore, and contains a slew of default standards.
---
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |
## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_iam_role.iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_path"></a> [artifact\_path](#input\_artifact\_path) | Path to use in container for build as well as appended to artifact\_name for full prefix, if more than one folder, must start without slash and separate folders with backslashes | `string` | `"artifacts"` | no |
| <a name="input_artifact_s3_bucket_arn"></a> [artifact\_s3\_bucket\_arn](#input\_artifact\_s3\_bucket\_arn) | ARN of S3 Bucket to place artifact into | `string` | n/a | yes |
| <a name="input_artifact_s3_bucket_id"></a> [artifact\_s3\_bucket\_id](#input\_artifact\_s3\_bucket\_id) | Name of S3 Bucket to place artifact into | `string` | n/a | yes |
| <a name="input_build_command_override"></a> [build\_command\_override](#input\_build\_command\_override) | MSBuild command to use if overriding default build | `string` | `null` | no |
| <a name="input_build_configuration"></a> [build\_configuration](#input\_build\_configuration) | .Net configuration to use for msbuild, usually release | `string` | `"Release"` | no |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | Timeout in minutes for the build job | `number` | `30` | no |
| <a name="input_codebuild_description"></a> [codebuild\_description](#input\_codebuild\_description) | Description of codebuild project | `string` | `null` | no |
| <a name="input_codebuild_name"></a> [codebuild\_name](#input\_codebuild\_name) | Name to be used for Codebuild Project and Role | `string` | n/a | yes |
| <a name="input_compute_type"></a> [compute\_type](#input\_compute\_type) | Size of build container | `string` | `"BUILD_GENERAL1_MEDIUM"` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Container image to use for build | `string` | `"mcr.microsoft.com/dotnet/framework/sdk:4.8"` | no |
| <a name="input_git_clone_depth"></a> [git\_clone\_depth](#input\_git\_clone\_depth) | Depth of clones | `number` | `1` | no |
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to resources | `map(string)` | <pre>{<br>  "Developer": "GenesisFunction",<br>  "Provisioner": "Terraform"<br>}</pre> | no |
| <a name="input_source_location"></a> [source\_location](#input\_source\_location) | This is the http path to the repo, like would be used for git clone | `string` | n/a | yes |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | Must be supported target, like BITBUCKET | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_artifact_output_path"></a> [default\_artifact\_output\_path](#output\_default\_artifact\_output\_path) | Default full path to zip file output in S3 Bucket |
---
Note, manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml`
<!-- END_TF_DOCS -->