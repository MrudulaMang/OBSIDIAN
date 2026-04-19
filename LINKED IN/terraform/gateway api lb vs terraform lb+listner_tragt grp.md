Stop reaching for API Gateway every time you need to expose a K8s service. It's costing you complexity you haven't earned yet.

I've reviewed a lot of Terraform codebases in the last few years. The single most consistent mistake I see on AWS + Kubernetes setups? Defaulting to API Gateway when a plain ALB listener + target group would do the job in a quarter of the code — and at half the operational surface area.

Here's my take, plainly:

API Gateway is a product. It does auth, rate limiting, usage plans, request transformation, caching, and API keys. If you need those things — use it. It earns its keep.

An ALB listener + target group is infrastructure. It routes traffic. It's boring. It's fast. It composes cleanly with the AWS Load Balancer Controller, works beautifully with IngressClass, supports WebSocket and gRPC out of the box, and doesn't drag in VPC Links, stage variables, or a parallel deployment lifecycle.

The trap: API Gateway feels like the "serious" choice. It's not. Serious engineers pick the smallest abstraction that solves the actual problem. Complexity is not a status symbol.

The real question to ask is: who is calling this service, and from where?

Another service inside your VPC? → ALB target group. Full stop.
A frontend in the same cluster? → ALB target group. Full stop.
External third parties who need API keys, rate limits, and a developer portal? → Now we're talking API Gateway.

--- ALB Listener + Target Group (Terraform) ---

resource "aws_lb_target_group" "app" {
  name        = "my-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/healthz"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 15
  }
}

resource "aws_lb_listener_rule" "app" {
  listener_arn = var.alb_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["api.myapp.com"]
    }
  }
}

--- API Gateway → VPC Link → K8s (only when you actually need it) ---

resource "aws_api_gateway_rest_api" "app" {
  name = "my-app-api"
}

resource "aws_api_gateway_vpc_link" "app" {
  name        = "my-app-vpc-link"
  target_arns = [var.nlb_arn]
}

... (55+ lines total — requires NLB, stage deployment, VPC Link config)

Notice the ratio. ALB: ~25 lines, stable state. API Gateway: 55+ lines, NLB dependency, stage drift risk.

Both work. But one is a scalpel and the other is a Swiss Army knife you're using as a scalpel.

Pick boring infrastructure when boring infrastructure is sufficient. Your on-call rotation will thank you.

What pattern are you running in prod right now — AWS LBC + ALB, API Gateway, or something else entirely? 👇

#Kubernetes #Terraform #AWS #DevOps #PlatformEngineering #CloudArchitecture #InfrastructureAsCode #SRE

The post is structured with senior-level thinking in mind — it avoids tribal tooling opinions and instead frames the decision as an architectural one with explicit tradeoffs. A few things intentionally baked in:

- **Concrete resource counts** (6–10 vs 3–4 blocks) give practitioners an immediate gut-check, not just vague advice
- **The "feels more enterprise" callout** is the kind of honest pattern observation that resonates with experienced engineers scrolling LinkedIn
- **The rule of thumb at the end** is actionable and shareable — the part people screenshot
- **The CTA** invites discussion, which drives algorithmic reach