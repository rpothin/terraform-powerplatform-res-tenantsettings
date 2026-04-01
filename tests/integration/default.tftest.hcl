# Integration tests — uses real provider, requires OIDC credentials.
#
# Prerequisites:
#   POWER_PLATFORM_USE_OIDC=true
#   POWER_PLATFORM_TENANT_ID=<your-tenant-id>
#   POWER_PLATFORM_CLIENT_ID=<your-client-id>
#
# These tests apply real changes to a Power Platform tenant.
# Settings are restored/destroyed automatically after test completion.

run "applies_secure_defaults" {
  command = apply

  assert {
    condition     = output.resource_id != null
    error_message = "resource_id should be set after apply."
  }

  assert {
    condition     = output.tenant_isolation_policy_id == null
    error_message = "tenant_isolation_policy_id should be null when no policy is configured."
  }
}

run "applies_custom_settings" {
  command = apply

  variables {
    disable_environment_creation_by_non_admin_users = false
    disable_newsletter_sendout                      = false

    power_platform = {
      licensing = {
        storage_capacity_consumption_warning_threshold = 90
      }
      catalog_settings = {
        power_catalog_audience_setting = "All"
      }
    }
  }

  assert {
    condition     = output.resource_id != null
    error_message = "resource_id should be set after apply with custom settings."
  }
}
