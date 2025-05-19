resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/webshop/backend"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This alarm triggers if CPU usage exceeds 70%"
  alarm_actions       = []  # You can add SNS notification ARN here
  dimensions = {
    InstanceId = aws_instance.app_server.id
  }
}

resource "aws_cloudwatch_dashboard" "backend_dashboard" {
  dashboard_name = "WebshopBackendDashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0, y = 0, width = 12, height = 6,
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", "${aws_instance.app_server.id}" ]
          ],
          period = 300,
          stat = "Average",
          region = var.aws_region,
          title = "EC2 CPU Usage"
        }
      }
    ]
  })
}
