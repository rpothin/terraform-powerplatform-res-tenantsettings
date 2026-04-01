output "resource_id" {
  description = "The ID of the Power Platform tenant settings resource."
  value       = module.this.resource_id
}

output "tenant_isolation_policy_id" {
  description = "The ID of the tenant isolation policy."
  value       = module.this.tenant_isolation_policy_id
}
