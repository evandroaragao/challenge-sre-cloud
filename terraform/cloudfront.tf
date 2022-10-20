resource "aws_cloudfront_distribution" "cf" {
  depends_on = [aws_lb.alb]
  comment = "Cloudfront web proxy"
  enabled = true

  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = aws_lb.alb.dns_name

    custom_origin_config {
      http_port               = 80
      https_port              = 443
      origin_protocol_policy  = "http-only"
      origin_ssl_protocols    = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods           = ["GET", "HEAD"]
    cached_methods            = ["GET", "HEAD"]
    target_origin_id          = aws_lb.alb.dns_name
    viewer_protocol_policy    = "allow-all" #That's because the need to access using HTTP and HTTPS
    min_ttl                   = 0
    max_ttl                   = 0
    default_ttl               = 0

    forwarded_values {
      query_string   = true
      headers        = ["Host"]
  
      cookies {
          forward    = "all"
      }
    }

  }



  restrictions {
    geo_restriction {
        restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2018" 
  }

}