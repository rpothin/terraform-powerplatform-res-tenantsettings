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
  source  = "rpothin/power-platform/tenantsettings"
  version = "~> 0.1"
}
```

To customize specific settings while keeping secure defaults for everything else:

```hcl
module "tenant_settings" {
  source  = "rpothin/power-platform/tenantsettings"
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
