output "lb_taget_group_arn" {
  value = aws_lb_target_group.my_target_group.arn
}
// dns name  
output "load_balancer_dns_name" {
  value = aws_lb.asmaa_lb.arn
}
output "load_balancer_zone_id" {
  value = aws_lb.asmaa_lb.zone_id
}