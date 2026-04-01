output "resource_id" {
  description = "The ID of the Power Platform tenant settings resource."
  value       = powerplatform_tenant_settings.this.id
}

output "tenant_isolation_policy_id" {
  description = "The ID of the tenant isolation policy. Null if no isolation policy was created."
  value       = length(powerplatform_tenant_isolation_policy.this) > 0 ? powerplatform_tenant_isolation_policy.this[0].id : null
}
