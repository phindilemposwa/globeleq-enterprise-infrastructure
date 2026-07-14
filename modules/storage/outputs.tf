output "bronze_bucket_arn" {
  description = "ARN of the bronze (raw) S3 bucket"
  value       = aws_s3_bucket.bronze.arn
}

output "bronze_bucket_name" {
  description = "Name of the bronze S3 bucket"
  value       = aws_s3_bucket.bronze.id
}

output "silver_bucket_arn" {
  description = "ARN of the silver (cleaned) S3 bucket"
  value       = aws_s3_bucket.silver.arn
}

output "silver_bucket_name" {
  description = "Name of the silver S3 bucket"
  value       = aws_s3_bucket.silver.id
}

output "gold_bucket_arn" {
  description = "ARN of the gold (business-ready) S3 bucket"
  value       = aws_s3_bucket.gold.arn
}

output "gold_bucket_name" {
  description = "Name of the gold S3 bucket"
  value       = aws_s3_bucket.gold.id
}
