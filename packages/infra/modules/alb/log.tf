resource "aws_s3_bucket" "access_logs" {
  bucket = "delivery-tracker-${var.environment}-access-logs"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.access_logs.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["582318560864"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.access_logs.arn}/*",
    ]
  }
}
