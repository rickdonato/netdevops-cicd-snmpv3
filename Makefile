.DEFAULT_GOAL := help

export VIRL_HOST=172.29.236.133
export VIRL_USERNAME=guest
export VIRL_PASSWORD=guest
export ANSIBLE_HOST_KEY_CHECKING=False
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export PATH=$$PATH:./venv/bin:/usr/local/bin:/usr/bin:/bin

.PHONY: help
help:
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | \
	sort | \
	awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'
	
.PHONY: install-deps
install-deps: ## Install pip
	apt-get update -y
	apt-get install python-pip -y

.PHONY: add-venv
add-venv: ## Install virtualenv, create virtualenv, install requirements
	pip install virtualenv
	virtualenv venv
	. ./venv/bin/activate
	@echo installing requirements.txt ...
	@venv/bin/pip install -q -r ./requirements.txt

.PHONY: format
format: ## Remove end of line spaces from yaml files
	find ./ \( -name *.yaml -o -name *.yml \) | xargs sed -i  "s/\s *$$//g"

.PHONY: lint
lint: ## Perform linting against ansible yaml files
	. ./venv/bin/activate
	find ./ansible/ \( -name *.yaml -o -name *.yml \) -exec ansible-lint {} +

.PHONY: start-test-network
start-virl-test-network: ## Start test network via VIRL
	. ./venv/bin/activate
	virl up -e test-network --provision -f virl/test.virl
	virl ls | grep test | grep ACTIVE

.PHONY: configure-test-network
configure-test-network: ## Configure test network
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/test ansible/playbooks/snmp-deploy.yaml

.PHONY: run-tests-test-network
run-tests-test-network: ## Rum tests against test network
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/test ansible/playbooks/snmp-test.yaml

.PHONY: configure-prod-network
configure-prod-network: ## Configure prod network
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/prod ansible/playbooks/snmp-deploy.yaml

.PHONY: run-tests-prod-network
run-tests-prod-network: ## Run tests against prod network
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/prod ansible/playbooks/snmp-test.yaml

.PHONY: stop-test-network
stop-test-network: ## Stop test network in VIRL
	. ./venv/bin/activate
	virl down test-network

.PHONY: remove-venv
remove-venv: ## Remove virtualenv
	. ./venv/bin/activate
	rm -rf ./venv

# :%s/^[ ]\+/\t/g - automatically replace all tabs with spaces
