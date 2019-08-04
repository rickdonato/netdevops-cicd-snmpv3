.DEFAULT_GOAL := all

export VIRL_HOST=172.29.236.133
export VIRL_USERNAME=guest
export VIRL_PASSWORD=guest
export ANSIBLE_HOST_KEY_CHECKING=False
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

.PHONY: all
all:    venv deps fmt lint build deploy test clean

.PHONY: apt
apt:
	apt-get update -y
	apt-get install python-pip -y

.PHONY: venv
venv:
	pip install virtualenv
	virtualenv venv
	. ./venv/bin/activate
	pip install -r ./requirements.txt

.PHONY: fmt
fmt:
	sudo find ./ \( -name *.yaml -o -name *.yml \) | xargs sed -i  "s/\s *$$//g"

.PHONY: lint
lint:
	. ./venv/bin/activate
	find ./ansible/ \( -name *.yaml -o -name *.yml \) -exec ansible-lint {} +

.PHONY: build
build:
	. ./venv/bin/activate
	virl up -e test-network --provision

.PHONY: deploy
deploy:
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/hosts_test ansible/playbooks/snmp-deploy.yaml

.PHONY: test
test:
	. ./venv/bin/activate
	ansible-playbook -i ansible/inventory/hosts_test ansible/playbooks/snmp-test.yaml

.PHONY: clean
clean:
	. ./venv/bin/activate
	virl down test-network
	rm -vf .virl/test-network/id
	rm -vrf ./venv

# :%s/^[ ]\+/\t/g - automatically replace all tabs with spaces
