# modules/glue/main.tf
resource "aws_glue_job" "data_transformation" {
  name     = "${var.project_name}-transformation-job"
  role_arn = var.glue_role_arn

  command {
    script_location = "s3://${var.script_bucket}/${var.script_key}"
    python_version = "3"
  }

  default_arguments = {
    "--job-language"                   = "python"
    "--class"                          = "GlueApp"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"   = "true"
    "--input-path"                     = "s3://${var.ingestion_bucket}"
    "--output-path"                    = "s3://${var.data_lake_bucket}"
  }

  execution_property {
    max_concurrent_runs = 1
  }

  glue_version = "3.0"
}

resource "aws_glue_workflow" "data_pipeline" {
  name = "${var.project_name}-workflow"
}

resource "aws_glue_trigger" "job_trigger" {
  name          = "${var.project_name}-job-trigger"
  type          = "SCHEDULED"
  workflow_name = aws_glue_workflow.data_pipeline.name

  schedule = "cron(0 1 * * ? *)" # Run daily at 1 AM UTC

  actions {
    job_name = aws_glue_job.data_transformation.name
  }
}

