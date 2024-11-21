# modules/iam/outputs.tf
output "glue_role_arn" {
  value = aws_iam_role.glue_role.arn
}

output "ec2_data_transfer_role_arn" {
  value = aws_iam_role.ec2_data_transfer_role.arn
}