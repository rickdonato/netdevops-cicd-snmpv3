.DEFAULT_GOAL := all

VIRL_HOST=172.29.236.133
VIRL_USERNAME=guest
VIRL_PASSWORD=guest

.PHONY: all
all:	venv install fmt lint build deploy test clean

.PHONY: venv
venv:
	apt-get update -y
	apt-get install python-pip -y
	pip install virtualenv

.PHONY: install
install:
	virtualenv venv
        source venv/bin/activate
        pip install -r ./requirements.txt
        
.PHONY: fmt
fmt:
        sudo find ./ \( -name *.yaml -o -name *.yml \) -exec sed -i  's/\ *$//g' {} \;

.PHONY: lint
lint:
        virtualenv venv
        find ./ansible/ \( -name *.yaml -o -name *.yml \) -exec ansible-lint {} +
 
.PHONY: build
build:
	. ./venv/bin/activate
        virl up -e test-network --provision

.PHONY: deploy
deploy:
	. ./venv/bin/activate
	./ansible/ansible-playbook -i inventory/hosts_test playbooks/snmp-deploy.yaml

.PHONY: test
test:
	. ./venv/bin/activate
	./ansible/ansible-playbook -i inventory/hosts_test playbooks/snmp-test.yaml	

.PHONY: clean
clean:
	virl down test-network
	. ./venv/bin/deactivate
	rm -rf ./venv
