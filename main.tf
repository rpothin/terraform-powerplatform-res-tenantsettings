resource "powerplatform_tenant_settings" "this" {
  walk_me_opt_out                                       = var.walk_me_opt_out
  disable_support_tickets_visible_by_all_users          = var.disable_support_tickets_visible_by_all_users
  disable_trial_environment_creation_by_non_admin_users = var.disable_trial_environment_creation_by_non_admin_users
  disable_capacity_allocation_by_environment_admins     = var.disable_capacity_allocation_by_environment_admins
  disable_environment_creation_by_non_admin_users       = var.disable_environment_creation_by_non_admin_users
  disable_portals_creation_by_non_admin_users           = var.disable_portals_creation_by_non_admin_users
  disable_newsletter_sendout                            = var.disable_newsletter_sendout

  power_platform = {
    search = {
      disable_docs_search       = var.power_platform.search.disable_docs_search
      disable_community_search  = var.power_platform.search.disable_community_search
      disable_bing_video_search = var.power_platform.search.disable_bing_video_search
    }

    teams_integration = {
      share_with_colleagues_user_limit = var.power_platform.teams_integration.share_with_colleagues_user_limit
    }

    power_apps = {
      disable_share_with_everyone              = var.power_platform.power_apps.disable_share_with_everyone
      enable_guests_to_make                    = var.power_platform.power_apps.enable_guests_to_make
      disable_maker_match                      = var.power_platform.power_apps.disable_maker_match
      disable_unused_license_assignment        = var.power_platform.power_apps.disable_unused_license_assignment
      disable_connection_sharing_with_everyone = var.power_platform.power_apps.disable_connection_sharing_with_everyone
    }

    power_automate = {
      disable_copilot = var.power_platform.power_automate.disable_copilot
    }

    environments = {
      disable_preferred_data_location_for_teams_environment = var.power_platform.environments.disable_preferred_data_location_for_teams_environment
    }

    governance = {
      disable_admin_digest                                      = var.power_platform.governance.disable_admin_digest
      disable_developer_environment_creation_by_non_admin_users = var.power_platform.governance.disable_developer_environment_creation_by_non_admin_users
      enable_default_environment_routing                        = var.power_platform.governance.enable_default_environment_routing
      environment_routing_all_makers                            = var.power_platform.governance.environment_routing_all_makers
      environment_routing_target_environment_group_id           = var.power_platform.governance.environment_routing_target_environment_group_id
      environment_routing_target_security_group_id              = var.power_platform.governance.environment_routing_target_security_group_id

      policy = {
        enable_desktop_flow_data_policy_management = var.power_platform.governance.policy.enable_desktop_flow_data_policy_management
      }
    }

    licensing = {
      disable_billing_policy_creation_by_non_admin_users    = var.power_platform.licensing.disable_billing_policy_creation_by_non_admin_users
      enable_tenant_capacity_report_for_environment_admins  = var.power_platform.licensing.enable_tenant_capacity_report_for_environment_admins
      storage_capacity_consumption_warning_threshold        = var.power_platform.licensing.storage_capacity_consumption_warning_threshold
      enable_tenant_licensing_report_for_environment_admins = var.power_platform.licensing.enable_tenant_licensing_report_for_environment_admins
      disable_use_of_unassigned_ai_builder_credits          = var.power_platform.licensing.disable_use_of_unassigned_ai_builder_credits
      apply_auto_claim_to_only_managed_environments         = var.power_platform.licensing.apply_auto_claim_to_only_managed_environments
    }

    power_pages = {}

    champions = {
      disable_champions_invitation_reachout    = var.power_platform.champions.disable_champions_invitation_reachout
      disable_skills_match_invitation_reachout = var.power_platform.champions.disable_skills_match_invitation_reachout
    }

    intelligence = {
      disable_copilot                   = var.power_platform.intelligence.disable_copilot
      disable_copilot_feedback          = var.power_platform.intelligence.disable_copilot_feedback
      disable_copilot_feedback_metadata = var.power_platform.intelligence.disable_copilot_feedback_metadata
    }

    model_experimentation = {
      enable_model_data_sharing = var.power_platform.model_experimentation.enable_model_data_sharing
      disable_data_logging      = var.power_platform.model_experimentation.disable_data_logging
    }

    catalog_settings = {
      power_catalog_audience_setting = var.power_platform.catalog_settings.power_catalog_audience_setting
    }

    user_management_settings = {
      enable_delete_disabled_user_in_all_environments = var.power_platform.user_management_settings.enable_delete_disabled_user_in_all_environments
    }
  }
}

resource "powerplatform_tenant_isolation_policy" "this" {
  count = var.tenant_isolation_policy != null ? 1 : 0

  is_disabled = var.tenant_isolation_policy.is_disabled

  allowed_tenants = var.tenant_isolation_policy.allowed_tenants
}
