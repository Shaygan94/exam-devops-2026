resource "aws_cloudwatch_dashboard" "wishifai" {
  dashboard_name = "wishifai-${var.candidate_number}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "Rekogntion and bedrock latency"
          view   = "timeSeries"
          period = 60
          stat   = "Maximum"
          metrics = [
            ["Wishifai-13", "app.rekognition.duration.max"],
            ["Wishifai-13", "app.bedrock.duration.max"]
          ]
          yAxis = { left = { label = "milliseconds" } }
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "Gift reccomendation per analysis"
          view   = "timeSeries"
          period = 60
          stat   = "Average"
          metrics = [
            ["Wishifai-13", "app.gifts.suggestions.per.analysis.avg"]
          ]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "ECS CPU and Memory"
          view   = "timeSeries"
          period = 60
          stat   = "Maximum"
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", "wishifai-service-${var.candidate_number}", "ClusterName", "default"],
            ["AWS/ECS", "MemoryUtilization", "ServiceName", "wishifai-service-${var.candidate_number}", "ClusterName", "default"]
          ]
          yAxis = { left = { label = "percentage" } }
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "Total sum gifts generated"
          view   = "timeSeries"
          period = 60
          stat   = "Sum"
          metrics = [
            ["Wishifai-13", "app.gifts.suggested.total.count"]
          ]
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "gifts_per_analysis_too_high" {
  alarm_name          = "wishifai-${var.candidate_number}-gifts-over-5"
  alarm_description   = "Bedrock returns more than 5 gifts - Ai is ignoring the prompt - Basert på analysen over, foreslå inntil 5 gaver som faktisk"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "app.gifts.suggestions.per.analysis.max"
  namespace           = "Wishifai-13"
  period              = 60
  statistic           = "Maximum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
}