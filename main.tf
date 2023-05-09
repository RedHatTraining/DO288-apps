variable "region" {
  default = "us-west-2"
}

variable "domain_name" {
  default = "mikeball.me"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "site" {
  bucket = "${var.domain_name}"
  region = "${var.region}"
  acl = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadForGetBucketObjects",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": ["arn:aws:s3:::${var.domain_name}/*"]
  }]
}
EOF
}

resource "aws_s3_bucket" "wwwsite" {
  bucket = "www.${var.domain_name}"
  region = "${var.region}"
  acl = "public-read"
  website {
    redirect_all_requests_to = "${var.domain_name}"
  }
}

resource "aws_s3_bucket_object" "index_file" {
  bucket = "${var.domain_name}"
  source = "../dist/index.html"
  key = "index.html"
  etag = "${md5(file("../dist/index.html"))}"
  content_type = "text/html"
  depends_on = [
    "aws_s3_bucket.site"
  ]
}

resource "aws_s3_bucket_object" "error_file" {
  bucket = "${var.domain_name}"
  source = "../dist/error.html"
  key = "error.html"
  etag = "${md5(file("../dist/error.html"))}"
  content_type = "text/html"
  depends_on = [
    "aws_s3_bucket.site"
  ]
}

resource "aws_s3_bucket_object" "css_file" {
  bucket = "${var.domain_name}"
  source = "../dist/assets/stylesheets/application.css"
  key = "assets/stylesheets/application.css"
  etag = "${md5(file("../dist/assets/stylesheets/application.css"))}"
  content_type = "text/css"
  depends_on = [
    "aws_s3_bucket.site"
  ]
}

resource "aws_s3_bucket_object" "image_file" {
  bucket = "${var.domain_name}"
  source = "../dist/assets/images/scape_long.png"
  key = "assets/images/scape_long.png"
  etag = "${md5(file("../dist/assets/images/scape_long.png"))}"
  content_type = "image/png"
  depends_on = [
    "aws_s3_bucket.site"
  ]
}

resource "aws_route53_zone" "primary" {
  name = "${var.domain_name}"
}

resource "aws_route53_record" "site" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name = "${var.domain_name}"
  type = "A"
  alias {
    name = "${aws_s3_bucket.site.website_domain}"
    zone_id = "${aws_s3_bucket.site.hosted_zone_id}"
    evaluate_target_health = false
  }
}
