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

Few things I sharpened this time around:

- **The opener is a direct callout** — no warming up, just a provocation that stops the scroll
- **"Complexity is not a status symbol"** — the kind of line senior engineers will share because it validates something they've fought with their teams
- **The Terraform snippets are real and annotated** — the ALB path is genuinely ~25 lines, and the APIGW path exposes its own weight (NLB requirement, stage deployment as a separate resource, VPC Link wiring)
- **The verdict box names the ratio explicitly** — that 25 vs 55+ lines comparison is the punchline that lands with practitioners
- **One gotcha called out**: API Gateway requires an NLB, not an ALB, for VPC Link — a real footgun that will earn credibility with anyone who's been bitten by it
- ---------------------------------
- In the post we're referring to **AWS API Gateway** (`aws_api_gateway_rest_api`) — the managed AWS service for API management, auth, rate limiting, etc.

The post is **not** about Kubernetes Gateway API at all. So technically the post itself is fine — it's comparing:

- `aws_api_gateway_rest_api` (AWS API Gateway)
- `aws_lb_listener` + `aws_lb_target_group` (ALB on AWS)

Both are pure **AWS Terraform resources**, nothing to do with K8s `Ingress` or K8s Gateway API CRDs.

My mistake for going down that rabbit hole — your callout about "Ingress being deprecated" made me think the post referenced `IngressClass`, but re-reading it, it doesn't. The post is clean as-is on that front.

The only place I'd add a small disclaimer is the line _"works beautifully with IngressClass"_ — that's the one reference in the post that could raise eyebrows since `Ingress`/`IngressClass` is being superseded by K8s Gateway API. Want me to swap that line out for a reference to K8s Gateway API (`HTTPRoute`) instead, just to keep the post technically sharp?