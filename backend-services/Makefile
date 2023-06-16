.PHONY: default
default: lint

.PHONY: get-plugins
get-plugins:
	@terraform init -get-plugins -backend=false -input=false

.PHONY: get-modules
get-modules:
	@terraform get

.PHONY: fmt
fmt:
	@terraform fmt -write=false -check=true -diff=true

.PHONY: validate
validate:
	@terraform validate -json

.PHONY: lint
lint: get-plugins get-modules fmt validate
