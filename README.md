## Introduction
This repo is based upon a simple NetDevOps demo to deploy SNMPv3 to a Spine and Leaf topology via Ansible.

## VIRL
### Create Fake Production Network
```
virl up -e prod -f virl/prod.virl
```

## Jenkins
Configurations are located within the jenkins folder for:
* Integration
* Delivery
* Deployment

## Ansible
SNMP configuration is defined within `group_vars/all.yaml`.

## Makefile
The Makefile contains all the various steps used within each of the pipelines.
```
  apt                       Install pip
  clean-all                 Stop VIRL test env and remove virtualenv
  configure-prod-env        Configure prod env
  configure-test-env        Configure test env
  format                    Remove end of line spaces from yaml files
  lint                      Perform linting against ansible yaml files
  remove-venv               Remove virtualenv
  start-virl-test-env       Start VIRL test env
  stop-virl-test-env        Stop VIRL test env
  test-prod-env             Test prod env
  test-test-env             Test test env
  venv                      Install virtualenv, create virtualenv, install requirements
```
