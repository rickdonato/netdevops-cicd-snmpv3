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
	
.PHONY: apt
apt: ## Install pip
	apt-get update -y
	apt-get install python-pip -y

.PHONY: venv
venv: ## Install virtualenv, create virtualenv, install requirements
	pip install virtualenv
	virtualenv venv
	. ./venv/bin/activate
	@venv/bin/pip install -r ./requirements.txt

.PHONY: format
format: ## Remove end of line spaces from yaml files
	find ./ \( -name *.yaml -o -name *.yml \) | xargs sed -i  "s/\s *$$//g"

.PHONY: lint
lint: ## Perform linting against ansible yaml files
	. ./venv/bin/activate
	find ./ansible/ \( -name *.yaml -o -name *.yml \) -exec ansible-lint {} +

.PHONY: start-virl-test-env
start-virl-test-env: ## Start VIRL test env
	. ./venv/bin/activate
	virl up -e test-network --provision virl/test.virl

.PHONY: configure-test-env
configure-test-env: ## Configure test env
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/test ansible/playbooks/snmp-deploy.yaml

.PHONY: test-test-env
test-test-env: ## Test test env
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/test ansible/playbooks/snmp-test.yaml

.PHONY: configure-prod-env
configure-prod-env: ## Configure prod env
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/prod ansible/playbooks/snmp-deploy.yaml

.PHONY: test-prod-env
test-prod-env: ## Test prod env
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/prod ansible/playbooks/snmp-test.yaml

.PHONY: stop-virl-test-env
stop-virl-test-env: ## Stop VIRL test env
	. ./venv/bin/activate
	virl down test-network

.PHONY: remove-venv
remove-venv: ## Remove virtualenv
	. ./venv/bin/activate
	rm -rf ./venv

.PHONY: clean-all
clean-all: ## Stop VIRL test env and remove virtualenv
	stop-virl-test-env remove-venv
	
# :%s/^[ ]\+/\t/g - automatically replace all tabs with spaces
