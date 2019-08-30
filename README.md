## Introduction
This repo is based upon a simple NetDevOps demo to deploy SNMPv3 to a Spine and Leaf topology via Ansible.
VIRL is also used to create a virtual test network to validate the changes.

## VIRL
Topology files for test and prod are located within the `virl` dir.
```
.
└── virl
    ├── prod.virl
    └── test.virl
```
To create fake production network, using the following:
```
virl up -e prod -f virl/prod.virl
```

## Jenkins
Job XML's are located within the `jenkins` folder for:
* Integration
* Delivery
* Deployment

## Ansible
* SNMP configuration is defined within `group_vars/all.yaml`
* Hosts for the prod and test networks defined within `inventory` folder files.
* 2 playbooks included - deploy and test.

```
.
├── ansible
│   ├── ansible.cfg
│   ├── inventory
│   │   ├── prod
│   │   └── test
│   └── playbooks
│       ├── group_vars
│       │   └── all.yaml
│       ├── host_vars
│       ├── snmp-deploy.yaml
│       └── snmp-test.yaml
```

## Makefile
The Makefile contains all the various steps used within each of the pipelines.
```
  add-venv                  Install virtualenv, create virtualenv, install requirements
  configure-prod-network    Configure prod network
  configure-test-network    Configure test network
  distroy-test-network      Distroy test network in VIRL
  format                    Remove end of line spaces from yaml files
  install-deps              Install pip
  lint                      Perform linting against ansible yaml files
  remove-venv               Remove virtualenv
  run-tests-prod-network    Run tests against prod network
  run-tests-test-network    Rum tests against test network
  start-test-network        Start test network via VIRL
```
