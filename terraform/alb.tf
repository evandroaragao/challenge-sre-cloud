#Creates an application load balance to be connected to cloudfront distribution
resource "aws_lb" "alb" {
  depends_on = [null_resource.ansible_playbooks]
  name               = "challenge-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id,aws_subnet.public2.id]

  tags = local.tags
}

#Creates a target group
resource "aws_lb_target_group" "target_group" {
  depends_on = [aws_lb.alb]
  name     = "challenge-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

#Attaches EC2 instance to the target group
resource "aws_lb_target_group_attachment" "this" {
  depends_on = [aws_lb_target_group.target_group]
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.instance.id
  port             = 8080
}

#Creates a listener
resource "aws_lb_listener" "front_end" {
  depends_on = [aws_lb_target_group_attachment.this]
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}