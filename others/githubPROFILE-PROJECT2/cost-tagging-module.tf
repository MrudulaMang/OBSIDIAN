# terraform/modules/tagging/main.tf
#
# Enforced tagging module — every resource in this platform
# must pass through this module to get standard tags.
#
# Why this matters:
#   Without consistent tagging, AWS Cost Explorer is useless.
#   You get one big bill with no idea which team or service spent what.
#   With this module, every resource is tagged at creation time.

variable "required_tags" {
  description = "Tags that MUST be present on every resource"
  type = object({
    team        = string  # Engineering team (backend, frontend, platform, data)
    service     = string  # Service name (payments-api, auth-service, etc.)
    environment = string  # dev | staging | prod
    owner       = string  # Team lead email — for cost accountability
  })

  validation {
    condition     = contains(["dev", "staging", "prod"], var.required_tags.environment)
    error_message = "environment must be one of: dev, staging, prod"
  }

  validation {
    condition     = contains(["backend", "frontend", "platform", "data", "security"], var.required_tags.team)
    error_message = "team must be one of: backend, frontend, platform, data, security"
  }
}

variable "optional_tags" {
  description = "Additional optional tags"
  type        = map(string)
  default     = {}
}

locals {
  # Merge required + optional + auto-generated tags
  all_tags = merge(
    {
      Team        = var.required_tags.team
      Service     = var.required_tags.service
      Environment = var.required_tags.environment
      Owner       = var.required_tags.owner
      ManagedBy   = "terraform"
      LastUpdated = timestamp()
    },
    var.optional_tags
  )
}

output "tags" {
  description = "Complete tag map to pass to resources"
  value       = local.all_tags
}
