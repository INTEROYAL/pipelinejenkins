resource "aws_s3_bucket" "bucket" {
  bucket        = "cloudfroterrasv1616"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index7latest.html"
  }

  /*error_document {
    key = "error.html"
  }*/
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

locals {
  content_types = {
    ".html" : "text/html",
    ".css" : "text/css",
    ".js" : "text/javascript",
    ".mp4" : "video/mp4",
    ".png" : "image/png",
    ".webm" : "video/webm"
  }
}

resource "aws_s3_object" "file" {
  for_each     = fileset(path.module, "content/**/*.{html,css,js,mp4,png,webm,iframe,href}")
  bucket       = aws_s3_bucket.bucket.id
  key          = replace(each.value, "/^content//", "")
  source       = each.value
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  etag         = filemd5(each.value)
  tags         = var.common_tags
}

resource "aws_s3_object" "upload_images_png" {
  for_each     = fileset("${path.module}/", "*.png")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "image/png"
}

resource "aws_s3_object" "upload_images_jpeg" {
  for_each     = fileset("${path.module}/", "*.jpg")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "image/jpeg"
}

resource "aws_s3_object" "upload_html" {
  for_each     = fileset("${path.module}/", "*.html")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_object" "upload_audio" {
  for_each     = fileset("${path.module}/", "*.mp3")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "audio/mpeg"
}

#<!--______________________________________________________________________________SNS(DISABLED)___________________________________________________________________________________________-->
# resource "aws_sns_topic" "bucket_events" {
#   name = "bucket-events-topic"
# }

# # Variable for email addresses
# variable "email_addresses" {
#   type    = list(string)
#   default = ["interoyal20@gmail.com", "eamt89@gmail.com"]
# }

# # Create SNS topics for notifications
# resource "aws_sns_topic" "bucket_creation_topic" {
#   name = "bucket-creation-topic"
# }

# resource "aws_sns_topic" "bucket_termination_topic" {
#   name = "bucket-termination-topic"
# }

# resource "aws_sns_topic_policy" "bucket_creation_topic_policy" {
#   arn  = aws_sns_topic.bucket_creation_topic.arn

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Id      = "bucket-creation-topic-policy",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Principal = "*",
#         Action    = "sns:Publish",
#         Resource  = aws_sns_topic.bucket_creation_topic.arn,
#         Condition = {
#           ArnLike = {
#             "aws:SourceArn" = aws_s3_bucket.bucket.arn
#           }
#         }
#       },
#     ]
#   })
# }

# resource "aws_sns_topic_policy" "bucket_termination_topic_policy" {
#   arn  = aws_sns_topic.bucket_termination_topic.arn

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Id      = "bucket-termination-topic-policy",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Principal = "*",
#         Action    = "sns:Publish",
#         Resource  = aws_sns_topic.bucket_termination_topic.arn,
#         Condition = {
#           ArnLike = {
#             "aws:SourceArn" = aws_s3_bucket.bucket.arn
#           }
#         }
#       },
#     ]
#   })
# }

# # Subscribe emails to SNS topics
# resource "aws_sns_topic_subscription" "creation_subscription" {
#   for_each  = toset(var.email_addresses)
#   topic_arn = aws_sns_topic.bucket_creation_topic.arn
#   protocol  = "email"
#   endpoint  = each.key
# }

# resource "aws_sns_topic_subscription" "termination_subscription" {
#   for_each  = toset(var.email_addresses)
#   topic_arn = aws_sns_topic.bucket_termination_topic.arn
#   protocol  = "email"
#   endpoint  = each.key
# }
# <____________________________________________________________________________CLOUDWATCH(DISABLED)_______________________________________________________________________________________>


# resource "aws_cloudwatch_event_rule" "s3_object_created_rule" {
#   name        = "S3ObjectCreatedRule"
#   description = "Rule to capture S3 object creation events"
#   event_pattern = <<PATTERN
# {
#   "source": ["aws.s3"],
#   "detail": {
#     "eventName": ["PutObject"]
#   },
#   "resources": ["arn:aws:s3:::${aws_s3_bucket.bucket.id}"],
#   "detailType": ["AWS API Call via CloudTrail"]
# }
# PATTERN
# }

# resource "aws_cloudwatch_event_target" "s3_object_created_target" {
#   rule      = aws_cloudwatch_event_rule.s3_object_created_rule.name
#   arn       = aws_sns_topic.bucket_events.arn
# }

# resource "aws_cloudwatch_event_rule" "s3_object_deleted_rule" {
#   name        = "S3ObjectDeletedRule"
#   description = "Rule to capture S3 object deletion events"
#   event_pattern = <<PATTERN
# {
#   "source": ["aws.s3"],
#   "detail": {
#     "eventName": ["DeleteObject"]
#   },
#   "resources": ["arn:aws:s3:::${aws_s3_bucket.bucket.id}"],
#   "detailType": ["AWS API Call via CloudTrail"]
# }
# PATTERN
# }

# resource "aws_cloudwatch_event_target" "s3_object_deleted_target" {
#   rule      = aws_cloudwatch_event_rule.s3_object_deleted_rule.name
#   arn       = aws_sns_topic.bucket_events.arn
# }
