.DEFAULT_GOAL := all

export VIRL_HOST=172.29.236.133
export VIRL_USERNAME=guest
export VIRL_PASSWORD=guest
export ANSIBLE_HOST_KEY_CHECKING=False
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export PATH=$$PATH:./venv/bin:/usr/local/bin:/usr/bin:/bin

.PHONY: apt
apt:
	apt-get update -y
	apt-get install python-pip -y

.PHONY: venv
venv:
	pip install virtualenv
	virtualenv venv
	. ./venv/bin/activate
	venv/bin/pip install -r ./requirements.txt

.PHONY: format
format:
	find ./ \( -name *.yaml -o -name *.yml \) | xargs sed -i  "s/\s *$$//g"

.PHONY: lint
lint:
	. ./venv/bin/activate
	find ./ansible/ \( -name *.yaml -o -name *.yml \) -exec ansible-lint {} +

.PHONY: virl_test_env
virl_test_env:
	. ./venv/bin/activate
	virl up -e test-network --provision

.PHONY: test_deploy
test_deploy:
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/test ansible/playbooks/snmp-deploy.yaml

.PHONY: test_test
test_test:
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/test ansible/playbooks/snmp-test.yaml

.PHONY: prod_deploy
prod_deploy:
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/prod ansible/playbooks/snmp-deploy.yaml

.PHONY: prod_test
prod_test:
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/prod ansible/playbooks/snmp-test.yaml

.PHONY: clean
clean:
	. ./venv/bin/activate
	virl down test-network
	rm -rf ./venv

# :%s/^[ ]\+/\t/g - automatically replace all tabs with spaces
