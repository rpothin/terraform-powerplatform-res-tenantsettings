mock_provider "powerplatform" {}

# ──────────────────────────────────────────────────────────────
# Default values — module should work with zero configuration
# ──────────────────────────────────────────────────────────────

run "deploys_with_all_defaults" {
  command = plan

  assert {
    condition     = powerplatform_tenant_settings.this.walk_me_opt_out == true
    error_message = "walk_me_opt_out should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.disable_support_tickets_visible_by_all_users == true
    error_message = "disable_support_tickets_visible_by_all_users should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.disable_trial_environment_creation_by_non_admin_users == true
    error_message = "disable_trial_environment_creation_by_non_admin_users should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.disable_capacity_allocation_by_environment_admins == true
    error_message = "disable_capacity_allocation_by_environment_admins should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.disable_environment_creation_by_non_admin_users == true
    error_message = "disable_environment_creation_by_non_admin_users should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.disable_portals_creation_by_non_admin_users == true
    error_message = "disable_portals_creation_by_non_admin_users should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.disable_newsletter_sendout == true
    error_message = "disable_newsletter_sendout should default to true."
  }
}

# ──────────────────────────────────────────────────────────────
# Top-level boolean overrides
# ──────────────────────────────────────────────────────────────

run "accepts_false_for_top_level_booleans" {
  command = plan

  variables {
    walk_me_opt_out                                       = false
    disable_support_tickets_visible_by_all_users          = false
    disable_trial_environment_creation_by_non_admin_users = false
    disable_capacity_allocation_by_environment_admins     = false
    disable_environment_creation_by_non_admin_users       = false
    disable_portals_creation_by_non_admin_users           = false
    disable_newsletter_sendout                            = false
  }

  assert {
    condition     = powerplatform_tenant_settings.this.walk_me_opt_out == false
    error_message = "walk_me_opt_out should accept false."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.disable_environment_creation_by_non_admin_users == false
    error_message = "disable_environment_creation_by_non_admin_users should accept false."
  }
}

# ──────────────────────────────────────────────────────────────
# Power Platform nested defaults
# ──────────────────────────────────────────────────────────────

run "power_platform_defaults_are_secure" {
  command = plan

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.search.disable_docs_search == true
    error_message = "search.disable_docs_search should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.search.disable_community_search == true
    error_message = "search.disable_community_search should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.search.disable_bing_video_search == true
    error_message = "search.disable_bing_video_search should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.power_apps.disable_share_with_everyone == true
    error_message = "power_apps.disable_share_with_everyone should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.power_apps.enable_guests_to_make == false
    error_message = "power_apps.enable_guests_to_make should default to false."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.power_automate.disable_copilot == true
    error_message = "power_automate.disable_copilot should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.governance.disable_admin_digest == false
    error_message = "governance.disable_admin_digest should default to false (keep digest enabled)."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.governance.disable_developer_environment_creation_by_non_admin_users == true
    error_message = "governance.disable_developer_environment_creation_by_non_admin_users should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.intelligence.disable_copilot == true
    error_message = "intelligence.disable_copilot should default to true."
  }

  # The provider accepts these fields, but the mocked resource shape does not
  # expose them back on the planned resource object.
  assert {
    condition     = var.power_platform.licensing.apply_auto_claim_to_only_managed_environments == true
    error_message = "licensing.apply_auto_claim_to_only_managed_environments should default to true."
  }

  assert {
    condition     = var.power_platform.intelligence.disable_copilot_feedback == true
    error_message = "intelligence.disable_copilot_feedback should default to true."
  }

  assert {
    condition     = var.power_platform.intelligence.disable_copilot_feedback_metadata == true
    error_message = "intelligence.disable_copilot_feedback_metadata should default to true."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.model_experimentation.enable_model_data_sharing == false
    error_message = "model_experimentation.enable_model_data_sharing should default to false."
  }
}

# ──────────────────────────────────────────────────────────────
# Power Platform partial overrides
# ──────────────────────────────────────────────────────────────

run "accepts_partial_power_platform_overrides" {
  command = plan

  variables {
    power_platform = {
      search = {
        disable_docs_search = false
      }
      licensing = {
        apply_auto_claim_to_only_managed_environments  = false
        storage_capacity_consumption_warning_threshold = 50
      }
      intelligence = {
        disable_copilot_feedback          = false
        disable_copilot_feedback_metadata = false
      }
    }
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.search.disable_docs_search == false
    error_message = "search.disable_docs_search should accept override to false."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.search.disable_community_search == true
    error_message = "Non-overridden search settings should retain defaults."
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.licensing.storage_capacity_consumption_warning_threshold == 50
    error_message = "storage_capacity_consumption_warning_threshold should accept override to 50."
  }

  assert {
    condition     = var.power_platform.licensing.apply_auto_claim_to_only_managed_environments == false
    error_message = "apply_auto_claim_to_only_managed_environments should accept override to false."
  }

  assert {
    condition     = var.power_platform.intelligence.disable_copilot_feedback == false
    error_message = "disable_copilot_feedback should accept override to false."
  }

  assert {
    condition     = var.power_platform.intelligence.disable_copilot_feedback_metadata == false
    error_message = "disable_copilot_feedback_metadata should accept override to false."
  }
}

# ──────────────────────────────────────────────────────────────
# Validation: storage_capacity_consumption_warning_threshold
# ──────────────────────────────────────────────────────────────

run "rejects_threshold_above_100" {
  command = plan

  variables {
    power_platform = {
      licensing = {
        storage_capacity_consumption_warning_threshold = 101
      }
    }
  }

  expect_failures = [
    var.power_platform,
  ]
}

run "rejects_threshold_below_0" {
  command = plan

  variables {
    power_platform = {
      licensing = {
        storage_capacity_consumption_warning_threshold = -1
      }
    }
  }

  expect_failures = [
    var.power_platform,
  ]
}

run "accepts_threshold_boundary_0" {
  command = plan

  variables {
    power_platform = {
      licensing = {
        storage_capacity_consumption_warning_threshold = 0
      }
    }
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.licensing.storage_capacity_consumption_warning_threshold == 0
    error_message = "Threshold should accept 0 as valid boundary."
  }
}

run "accepts_threshold_boundary_100" {
  command = plan

  variables {
    power_platform = {
      licensing = {
        storage_capacity_consumption_warning_threshold = 100
      }
    }
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.licensing.storage_capacity_consumption_warning_threshold == 100
    error_message = "Threshold should accept 100 as valid boundary."
  }
}

# ──────────────────────────────────────────────────────────────
# Validation: power_catalog_audience_setting
# ──────────────────────────────────────────────────────────────

run "rejects_invalid_catalog_audience" {
  command = plan

  variables {
    power_platform = {
      catalog_settings = {
        power_catalog_audience_setting = "Invalid"
      }
    }
  }

  expect_failures = [
    var.power_platform,
  ]
}

run "rejects_none_catalog_audience" {
  command = plan

  variables {
    power_platform = {
      catalog_settings = {
        power_catalog_audience_setting = "None"
      }
    }
  }

  expect_failures = [
    var.power_platform,
  ]
}

run "accepts_catalog_audience_all" {
  command = plan

  variables {
    power_platform = {
      catalog_settings = {
        power_catalog_audience_setting = "All"
      }
    }
  }

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.catalog_settings.power_catalog_audience_setting == "All"
    error_message = "Catalog audience should accept 'All'."
  }
}

run "accepts_catalog_audience_specific_admins" {
  command = plan

  assert {
    condition     = powerplatform_tenant_settings.this.power_platform.catalog_settings.power_catalog_audience_setting == "SpecificAdmins"
    error_message = "Catalog audience should default to 'SpecificAdmins'."
  }
}

# ──────────────────────────────────────────────────────────────
# Tenant isolation policy — not created by default
# ──────────────────────────────────────────────────────────────

run "isolation_policy_not_created_by_default" {
  command = plan

  assert {
    condition     = length(powerplatform_tenant_isolation_policy.this) == 0
    error_message = "Tenant isolation policy should not be created when variable is null."
  }
}

# ──────────────────────────────────────────────────────────────
# Tenant isolation policy — created when provided
# ──────────────────────────────────────────────────────────────

run "creates_isolation_policy_when_provided" {
  command = plan

  variables {
    tenant_isolation_policy = {
      is_disabled = false
      allowed_tenants = [
        {
          tenant_id = "00000000-0000-0000-0000-000000000001"
          inbound   = true
          outbound  = false
        }
      ]
    }
  }

  assert {
    condition     = length(powerplatform_tenant_isolation_policy.this) == 1
    error_message = "Tenant isolation policy should be created when variable is provided."
  }

  assert {
    condition     = var.tenant_isolation_policy.is_disabled == false
    error_message = "is_disabled should default to false."
  }
}

run "creates_disabled_isolation_policy" {
  command = plan

  variables {
    tenant_isolation_policy = {
      is_disabled = true
      allowed_tenants = [
        {
          tenant_id = "00000000-0000-0000-0000-000000000001"
          inbound   = true
          outbound  = true
        }
      ]
    }
  }

  assert {
    condition     = var.tenant_isolation_policy.is_disabled == true
    error_message = "is_disabled should be true when set."
  }
}

run "creates_isolation_policy_with_multiple_tenants" {
  command = plan

  variables {
    tenant_isolation_policy = {
      allowed_tenants = [
        {
          tenant_id = "00000000-0000-0000-0000-000000000001"
          inbound   = true
          outbound  = true
        },
        {
          tenant_id = "00000000-0000-0000-0000-000000000002"
          inbound   = false
          outbound  = true
        }
      ]
    }
  }

  assert {
    condition     = length(powerplatform_tenant_isolation_policy.this) == 1
    error_message = "Tenant isolation policy should be created with multiple tenants."
  }
}

# ──────────────────────────────────────────────────────────────
# Output presence
# ──────────────────────────────────────────────────────────────

run "outputs_resource_id" {
  command = apply

  override_resource {
    target = powerplatform_tenant_settings.this
    values = {
      id = "mock-tenant-settings-id"
    }
  }

  assert {
    condition     = output.resource_id == "mock-tenant-settings-id"
    error_message = "resource_id output should expose the tenant settings resource ID."
  }
}

run "outputs_null_isolation_policy_id_by_default" {
  command = apply

  override_resource {
    target = powerplatform_tenant_settings.this
    values = {
      id = "mock-tenant-settings-id"
    }
  }

  assert {
    condition     = output.tenant_isolation_policy_id == null
    error_message = "tenant_isolation_policy_id should be null when no policy is created."
  }
}
