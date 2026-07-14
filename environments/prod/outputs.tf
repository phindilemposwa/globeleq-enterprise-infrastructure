output "iam_role_arn" {
  value = module.iam.role_arn
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "bronze_bucket_name" {
  value = module.storage.bronze_bucket_name
}

output "ec2_instance_id" {
  value = module.compute.instance_id
}

output "ec2_public_ip" {
  value = module.compute.instance_public_ip
}
