# Power Platform Tenant Settings Module

[![Terraform Registry](https://img.shields.io/badge/Terraform-Registry-blue.svg)](https://registry.terraform.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

This module manages Power Platform tenant-wide settings and optional tenant isolation
policies. It wraps the `powerplatform_tenant_settings` and
`powerplatform_tenant_isolation_policy` provider resources into a single,
opinionated module with **secure-by-default** configuration.

## Key Features

- **Zero-config deployment** — all inputs are optional with security-hardened defaults
- **Tenant settings** — controls for environment creation, Copilot, data sharing, licensing, governance, and more
- **Tenant isolation** — optional cross-tenant connectivity policy with explicit allowlist
- **AVM-aligned** — follows [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/) conventions

## Usage

```hcl
module "tenant_settings" {
  source  = "rpothin/res-tenantsettings/power-platform"
  version = "~> 0.1"
}
```

To customize specific settings while keeping secure defaults for everything else:

```hcl
module "tenant_settings" {
  source  = "rpothin/res-tenantsettings/power-platform"
  version = "~> 0.1"

  disable_environment_creation_by_non_admin_users = false

  power_platform = {
    licensing = {
      storage_capacity_consumption_warning_threshold = 90
    }
  }
}
```

## Prerequisites

- Terraform >= 1.9, < 2.0
- Power Platform Terraform provider ~> 4.0
- Power Platform admin credentials (OIDC recommended)

## Secure Defaults

All inputs are optional. The module ships with the following security- and governance-aligned defaults. Override only the settings you need to relax.

### Top-level tenant settings

| Variable | Default | Rationale |
|---|---|---|
| `walk_me_opt_out` | `true` | Disables WalkMe third-party tracking (privacy) |
| `disable_support_tickets_visible_by_all_users` | `true` | Tickets visible only to creator and admins |
| `disable_trial_environment_creation_by_non_admin_users` | `true` | Prevents shadow-IT trial environments |
| `disable_capacity_allocation_by_environment_admins` | `true` | Centralises add-on capacity spend control |
| `disable_environment_creation_by_non_admin_users` | `true` | Admin-only environment creation |
| `disable_portals_creation_by_non_admin_users` | `true` | Admin-only Power Pages portal creation |
| `disable_newsletter_sendout` | `true` | Opts out of Microsoft marketing newsletters |

### `power_platform` nested defaults

| Field (relative to `power_platform`) | Default | Rationale |
|---|---|---|
| `search.disable_docs_search` | `true` | Route users to org-approved documentation |
| `search.disable_community_search` | `true` | Prevent unapproved community content |
| `search.disable_bing_video_search` | `true` | Prevent external video content in search |
| `teams_integration.share_with_colleagues_user_limit` | `10000` | Practical upper bound on sharing scope |
| `power_apps.disable_connection_sharing_with_everyone` | `true` | Prevent tenant-wide connection sharing |
| `power_apps.disable_maker_match` | `true` | Disable cross-tenant maker discovery (privacy) |
| `power_apps.disable_members_indicator` | `true` | Hide members indicator in apps (privacy) |
| `power_apps.disable_share_with_everyone` | `true` | Prevent tenant-wide app sharing |
| `power_apps.disable_unused_license_assignment` | `true` | Suppress automatic unused licence re-assignment |
| `power_apps.enable_guests_to_make` | `false` | Guest accounts cannot create apps |
| `power_automate.disable_copilot` | `true` | Copilot disabled until explicitly opted in |
| `power_automate.disable_copilot_with_bing` | `true` | Disables Bing data augmentation in Copilot |
| `environments.disable_preferred_data_location_for_teams_environment` | `true` | Enforces single data residency location |
| `governance.disable_admin_digest` | `false` | Admin digest is a useful operational signal |
| `governance.disable_developer_environment_creation_by_non_admin_users` | `true` | Admin-only developer environment creation |
| `governance.enable_default_environment_routing` | `false` | Prevent unexpected routing to personal envs |
| `governance.environment_routing_all_makers` | `false` | Route only new makers, not all |
| `governance.environment_routing_target_environment_group_id` | `null` | Must be set intentionally |
| `governance.environment_routing_target_security_group_id` | `null` | Must be set intentionally |
| `governance.policy.enable_desktop_flow_data_policy_management` | `true` | Desktop flow connectors subject to DLP |
| `licensing.apply_auto_claim_to_only_managed_environments` | `true` | Auto-claim limited to managed environments |
| `licensing.disable_billing_policy_creation_by_non_admin_users` | `true` | Admin-only billing policy creation |
| `licensing.disable_use_of_unassigned_ai_builder_credits` | `true` | Prevent uncontrolled AI Builder consumption |
| `licensing.enable_tenant_capacity_report_for_environment_admins` | `true` | Env admins can see capacity (observability) |
| `licensing.enable_tenant_licensing_report_for_environment_admins` | `true` | Env admins can see licence usage |
| `licensing.storage_capacity_consumption_warning_threshold` | `85` | Early warning before reaching storage limit |
| `champions.disable_champions_invitation_reachout` | `true` | Microsoft cannot reach out to users (privacy) |
| `champions.disable_skills_match_invitation_reachout` | `true` | Microsoft cannot reach out to users (privacy) |
| `intelligence.disable_copilot` | `true` | Copilot disabled until explicitly opted in |
| `intelligence.disable_copilot_feedback` | `true` | No feedback data sent to Microsoft |
| `intelligence.disable_copilot_feedback_metadata` | `true` | No metadata sent to Microsoft |
| `model_experimentation.disable_data_logging` | `true` | No experimentation data logging |
| `model_experimentation.enable_model_data_sharing` | `false` | No tenant data shared for model training |
| `catalog_settings.power_catalog_audience_setting` | `"SpecificAdmins"` | Least-privilege: catalog visible to designated admins only |
| `user_management_settings.enable_delete_disabled_user_in_all_environments` | `true` | Remove disabled accounts across all environments |

### Deprecated provider inputs (intentionally excluded)

The following provider inputs are marked `Deprecated` in the provider schema and are not exposed by this module to discourage their use:

| Input | Reason |
|---|---|
| `disable_nps_comments_reachout` | Deprecated by provider |
| `disable_survey_feedback` | Deprecated by provider |
| `power_platform.power_apps.disable_create_from_figma` | Deprecated by provider |
| `power_platform.power_apps.disable_create_from_image` | Deprecated by provider |
| `power_platform.intelligence.enable_open_ai_bot_publishing` | Deprecated by provider |
