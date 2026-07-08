# outputs.tf — Exposed deployment outputs

output "s3_bucket_name" {
  description = "Name of the private S3 bucket hosting site content."
  value       = aws_s3_bucket.site.id
}

output "s3_bucket_arn" {
  description = "ARN of the content S3 bucket."
  value       = aws_s3_bucket.site.arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.site.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name (use for CNAME or direct access)."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "site_url" {
  description = "Public URL of the deployed site."
  value       = local.use_custom_domain ? "https://${var.domain_name}" : "https://${aws_cloudfront_distribution.site.domain_name}"
}
