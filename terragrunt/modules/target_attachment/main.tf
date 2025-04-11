resource "aws_lb_target_group_attachment" "this" {
  for_each = toset(var.target_ids)

  target_group_arn = var.target_group_arn
  target_id        = each.value
  port             = var.port
}
