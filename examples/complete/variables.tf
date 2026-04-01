variable "allowed_tenant_id" {
  description = "The Azure AD tenant ID to allow in the tenant isolation policy."
  type        = string
  default     = "00000000-0000-0000-0000-000000000001"
}
