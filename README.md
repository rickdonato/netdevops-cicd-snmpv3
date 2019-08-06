WIP... and is in very early draft stages.

## Installation Steps
* install jenkins container
* apt-get install sudo make vim -y

* user mod - https://sgoyal.net/2016/11/18/run-a-shell-from-jenkins-using-sudo-ubuntu/

## CI
Performed via Makefile:
* venv
* deps
* fmt
* lint
* build
* deploy
* test
* clean

* merge to master
* perform same steps as above but with master branch
* perform same steps as above against prod

Note: add release and process of git issues.

## CD - Delivery

## CD - Deployment

## Caveats
Makefile - sed and $

## References
https://www.redhat.com/en/topics/devops/what-is-ci-cd

