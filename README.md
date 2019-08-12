// DRAFT //

## Introduction
This repo is based upon a simple NetDevOps demo to deploy SNMPv3 to a Spine and Leaf topology via Ansible.


## Installation Steps
* install jenkins container
* apt-get install sudo make vim -y
* user mod - https://sgoyal.net/2016/11/18/run-a-shell-from-jenkins-using-sudo-ubuntu/
* http://oss-world.blogspot.com/2015/08/merge-git-branches-using-jenkins.html
* https://packetflow.slack.com/apps/A0F7VRFKN

## Makefile
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

## Pipeline 1 - Auto
*Test test branch against VIRL test environment.
* Merge to master

## Pipeline 2 - Kicked from Pipeline1
* Test master branch against VIRL test environment.

## Pipeline 3 - Manual
* Configure prod and test prod.

## Caveats
* Makefile - sed and $
* Makefile - tabs and spaces

## References
https://www.redhat.com/en/topics/devops/what-is-ci-cd

