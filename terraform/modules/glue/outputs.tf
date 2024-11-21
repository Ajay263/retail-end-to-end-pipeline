# modules/glue/outputs.tf
output "glue_job_name" {
  value = aws_glue_job.data_transformation.name
}