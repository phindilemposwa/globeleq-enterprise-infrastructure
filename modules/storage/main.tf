# =============================================================================
# Storage Module
# Manages: S3 Buckets (Bronze/Silver/Gold), Lifecycle Rules, Encryption
# =============================================================================

# Bronze bucket - raw data landing zone
resource "aws_s3_bucket" "bronze" {
  bucket = "${var.project}-${var.environment}-bronze"

  tags = {
    Name        = "${var.project}-${var.environment}-bronze"
    Environment = var.environment
    Layer       = "bronze"
    ManagedBy   = "terraform"
  }
}

# Silver bucket - cleaned/transformed data
resource "aws_s3_bucket" "silver" {
  bucket = "${var.project}-${var.environment}-silver"

  tags = {
    Name        = "${var.project}-${var.environment}-silver"
    Environment = var.environment
    Layer       = "silver"
    ManagedBy   = "terraform"
  }
}

# Gold bucket - business-ready/aggregated data
resource "aws_s3_bucket" "gold" {
  bucket = "${var.project}-${var.environment}-gold"

  tags = {
    Name        = "${var.project}-${var.environment}-gold"
    Environment = var.environment
    Layer       = "gold"
    ManagedBy   = "terraform"
  }
}

# Versioning
resource "aws_s3_bucket_versioning" "bronze" {
  bucket = aws_s3_bucket.bronze.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "silver" {
  bucket = aws_s3_bucket.silver.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "gold" {
  bucket = aws_s3_bucket.gold.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption (SSE-S3, free)
resource "aws_s3_bucket_server_side_encryption_configuration" "bronze" {
  bucket = aws_s3_bucket.bronze.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "silver" {
  bucket = aws_s3_bucket.silver.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "gold" {
  bucket = aws_s3_bucket.gold.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access on all buckets
resource "aws_s3_bucket_public_access_block" "bronze" {
  bucket                  = aws_s3_bucket.bronze.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "silver" {
  bucket                  = aws_s3_bucket.silver.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "gold" {
  bucket                  = aws_s3_bucket.gold.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
