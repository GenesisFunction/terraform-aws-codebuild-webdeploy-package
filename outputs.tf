output "default_artifact_output_path" {
  description = "Default full path to zip file output in S3 Bucket"
  value       = "/${var.codebuild_name}/${var.artifact_path}/${var.codebuild_name}.zip"
}
