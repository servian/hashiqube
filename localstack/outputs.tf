output "aws_s3_bucket_localstack-s3-bucket" {
  value = aws_s3_bucket.my-bucket
}

output "ec2_instance_with_index_zipmap" {
  value = zipmap(range(length(var.ec2_instance)), var.ec2_instance)
}

output "ec2_instance" {
  value = var.ec2_instance
}

output "ec2_instance_disk_allocations_flattened" {
  value = flatten(local.ec2_instance_disk_allocations_basic)
}

output "ec2_instance_disk_allocations_indexed" {
  value = zipmap(range(length(local.ec2_instance_disk_allocations_flattened)), local.ec2_instance_disk_allocations_flattened)
}
