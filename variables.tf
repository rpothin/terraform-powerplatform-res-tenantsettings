variable "walk_me_opt_out" {
  description = "Opt out of WalkMe third-party tracking. When true, WalkMe guided tours are disabled."
  type        = bool
  default     = true
  nullable    = false
}

variable "disable_support_tickets_visible_by_all_users" {
  description = "When true, support tickets are only visible to the creator and admins, not all users."
  type        = bool
  default     = true
  nullable    = false
}

variable "disable_trial_environment_creation_by_non_admin_users" {
  description = "When true, only admins can create trial environments. Prevents shadow IT."
  type        = bool
  default     = true
  nullable    = false
}

variable "disable_capacity_allocation_by_environment_admins" {
  description = "When true, only tenant admins can allocate add-on capacity. Centralizes spend control."
  type        = bool
  default     = true
  nullable    = false
}

variable "disable_environment_creation_by_non_admin_users" {
  description = "When true, only admins can create production and sandbox environments."
  type        = bool
  default     = true
  nullable    = false
}

variable "disable_portals_creation_by_non_admin_users" {
  description = "When true, only admins can create Power Pages portals."
  type        = bool
  default     = true
  nullable    = false
}

variable "disable_newsletter_sendout" {
  description = "When true, Power Platform marketing newsletters are not sent to users."
  type        = bool
  default     = true
  nullable    = false
}

variable "power_platform" {
  description = <<-EOT
    Power Platform tenant settings organized by category. All sub-attributes
    are optional with secure defaults. Categories: search, teams_integration,
    power_apps, power_automate, environments, governance, licensing,
    champions, intelligence, model_experimentation, catalog_settings,
    user_management_settings.
  EOT

  type = object({
    search = optional(object({
      disable_docs_search       = optional(bool, true)
      disable_community_search  = optional(bool, true)
      disable_bing_video_search = optional(bool, true)
    }), {})

    teams_integration = optional(object({
      share_with_colleagues_user_limit = optional(number, 10000)
    }), {})

    power_apps = optional(object({
      disable_connection_sharing_with_everyone = optional(bool, true)
      disable_maker_match                      = optional(bool, true)
      disable_members_indicator                = optional(bool, true)
      disable_share_with_everyone              = optional(bool, true)
      disable_unused_license_assignment        = optional(bool, true)
      enable_guests_to_make                    = optional(bool, false)
    }), {})

    power_automate = optional(object({
      disable_copilot           = optional(bool, true)
      disable_copilot_with_bing = optional(bool, true)
    }), {})

    environments = optional(object({
      disable_preferred_data_location_for_teams_environment = optional(bool, true)
    }), {})

    governance = optional(object({
      disable_admin_digest                                      = optional(bool, false)
      disable_developer_environment_creation_by_non_admin_users = optional(bool, true)
      enable_default_environment_routing                        = optional(bool, false)
      environment_routing_all_makers                            = optional(bool, false)
      environment_routing_target_environment_group_id           = optional(string, null)
      environment_routing_target_security_group_id              = optional(string, null)
      policy = optional(object({
        enable_desktop_flow_data_policy_management = optional(bool, true)
      }), {})
    }), {})

    licensing = optional(object({
      disable_billing_policy_creation_by_non_admin_users    = optional(bool, true)
      enable_tenant_capacity_report_for_environment_admins  = optional(bool, true)
      storage_capacity_consumption_warning_threshold        = optional(number, 85)
      enable_tenant_licensing_report_for_environment_admins = optional(bool, true)
      disable_use_of_unassigned_ai_builder_credits          = optional(bool, true)
      apply_auto_claim_to_only_managed_environments         = optional(bool, true)
    }), {})

    champions = optional(object({
      disable_champions_invitation_reachout    = optional(bool, true)
      disable_skills_match_invitation_reachout = optional(bool, true)
    }), {})

    intelligence = optional(object({
      disable_copilot                   = optional(bool, true)
      disable_copilot_feedback          = optional(bool, true)
      disable_copilot_feedback_metadata = optional(bool, true)
    }), {})

    model_experimentation = optional(object({
      enable_model_data_sharing = optional(bool, false)
      disable_data_logging      = optional(bool, true)
    }), {})

    catalog_settings = optional(object({
      power_catalog_audience_setting = optional(string, "SpecificAdmins")
    }), {})

    user_management_settings = optional(object({
      enable_delete_disabled_user_in_all_environments = optional(bool, true)
    }), {})
  })

  default  = {}
  nullable = false

  validation {
    condition     = var.power_platform.licensing.storage_capacity_consumption_warning_threshold >= 0 && var.power_platform.licensing.storage_capacity_consumption_warning_threshold <= 100
    error_message = "storage_capacity_consumption_warning_threshold must be between 0 and 100."
  }

  validation {
    condition     = contains(["All", "SpecificAdmins"], var.power_platform.catalog_settings.power_catalog_audience_setting)
    error_message = "power_catalog_audience_setting must be either 'All' or 'SpecificAdmins'."
  }

  validation {
    condition = var.power_platform.governance.environment_routing_target_environment_group_id == null || can(regex(
      "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$",
      var.power_platform.governance.environment_routing_target_environment_group_id
    ))
    error_message = "environment_routing_target_environment_group_id must be a valid UUID (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx) or null."
  }

  validation {
    condition = var.power_platform.governance.environment_routing_target_security_group_id == null || can(regex(
      "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$",
      var.power_platform.governance.environment_routing_target_security_group_id
    ))
    error_message = "environment_routing_target_security_group_id must be a valid UUID (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx) or null."
  }
}

variable "tenant_isolation_policy" {
  description = <<-EOT
    Configuration for the tenant isolation policy. When null (default), no
    isolation policy resource is created. When provided, creates a tenant
    isolation policy to control cross-tenant connectivity.

    - is_disabled: Whether the policy is disabled. Default false (policy is active).
    - allowed_tenants: Explicit set of external tenants allowed to connect.
      Each entry requires tenant_id, inbound, and outbound booleans.
  EOT

  type = object({
    is_disabled = optional(bool, false)
    allowed_tenants = set(object({
      tenant_id = string
      inbound   = bool
      outbound  = bool
    }))
  })

  default  = null
  nullable = true
}
