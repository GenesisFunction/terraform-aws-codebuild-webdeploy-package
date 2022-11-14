variable "codebuild_name" {
  description = "Name to be used for Codebuild Project and Role"
  type        = string
}

variable "codebuild_description" {
  description = "Description of codebuild project"
  type        = string
  default     = null
}

variable "source_type" {
  description = "Must be supported target, like BITBUCKET"
  type        = string
}

variable "source_location" {
  description = "This is the http path to the repo, like would be used for git clone"
  type        = string
}

variable "git_clone_depth" {
  description = "Depth of clones"
  type        = number
  default     = 1
}

# variable "artifact_name" {
#   description = "Name of root common prefix in S3 bucket where build artifact will be placed"
#   type        = string
# }

variable "artifact_path" {
  description = "Path to use in container for build as well as appended to artifact_name for full prefix, if more than one folder, must start without slash and separate folders with backslashes"
  type        = string
  default     = "artifacts"
}

variable "artifact_s3_bucket_id" {
  description = "Name of S3 Bucket to place artifact into"
  type        = string
}

variable "artifact_s3_bucket_arn" {
  description = "ARN of S3 Bucket to place artifact into"
  type        = string
}

variable "container_image" {
  description = "Container image to use for build"
  type        = string
  default     = "mcr.microsoft.com/dotnet/framework/sdk:4.8"
}

variable "compute_type" {
  description = "Size of build container"
  type        = string
  default     = "BUILD_GENERAL1_MEDIUM"
}

variable "build_timeout" {
  description = "Timeout in minutes for the build job"
  type        = number
  default     = 30
}

variable "build_configuration" {
  description = ".Net configuration to use for msbuild, usually release"
  type        = string
  default     = "Release"
}

variable "build_command_override" {
  description = "MSBuild command to use if overriding default build"
  type        = string
  default     = null
}

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default = {
    Developer   = "GenesisFunction"
    Provisioner = "Terraform"
  }
}
