.PHONY: fmt validate init test test-unit test-integration docs lint security-scan check-all provider-patch

PATCHED_PROVIDER_DIR := .patched-provider
TERRAFORMRC          := $(PATCHED_PROVIDER_DIR)/.terraformrc
PROVIDER_REPO        := https://github.com/microsoft/terraform-provider-power-platform.git
PROVIDER_TAG         := v4.1.0

fmt:
	terraform fmt -recursive

validate: init provider-patch
	TF_CLI_CONFIG_FILE=$(TERRAFORMRC) terraform validate

init:
	terraform init -backend=false

test: test-unit test-integration

test-unit: init provider-patch
	TF_CLI_CONFIG_FILE=$(TERRAFORMRC) terraform test -test-directory=tests/unit

test-integration: init provider-patch
	TF_CLI_CONFIG_FILE=$(TERRAFORMRC) terraform test -test-directory=tests/integration

docs:
	terraform-docs .
	for dir in examples/*/; do terraform-docs "$$dir"; done

lint:
	terraform fmt -check -recursive

security-scan:
	trivy config .

check-all: fmt validate docs lint security-scan test-unit

# Build a patched provider binary to work around upstream bug in
# powerplatform_tenant_isolation_policy ValidateConfig (set(object) handling).
# See: microsoft/terraform-provider-power-platform — AllowedTenantModel unknown-value error.
provider-patch: $(PATCHED_PROVIDER_DIR)/terraform-provider-power-platform

$(PATCHED_PROVIDER_DIR)/terraform-provider-power-platform:
	@echo "Building patched power-platform provider..."
	@mkdir -p $(PATCHED_PROVIDER_DIR)
	@if [ ! -d "$(PATCHED_PROVIDER_DIR)/src" ]; then \
		git clone --depth 1 --branch $(PROVIDER_TAG) $(PROVIDER_REPO) $(PATCHED_PROVIDER_DIR)/src; \
	fi
	@cd $(PATCHED_PROVIDER_DIR)/src && \
		sed -i '/var modelTenants \[\]AllowedTenantModel/i\\tif data.AllowedTenants.IsUnknown() || data.AllowedTenants.IsNull() {\n\t\treturn\n\t}\n' \
			internal/services/tenant_isolation_policy/resource_tenant_isolation_policy.go && \
		go build -o ../terraform-provider-power-platform .
	@printf 'provider_installation {\n  dev_overrides {\n    "microsoft/power-platform" = "%s"\n  }\n  direct {}\n}\n' \
		"$$(cd $(PATCHED_PROVIDER_DIR) && pwd)" > $(TERRAFORMRC)
	@echo "Patched provider built successfully."
