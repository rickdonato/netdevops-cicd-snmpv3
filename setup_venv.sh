#!/bin/bash

VENV_NAME=$1
ACTION=$2

create_venv() {
apt-get update -y
apt-get install python-pip -y
pip install virtualenv

virtualenv "${VENV_NAME}"
source "${VENV_NAME}"/bin/activate

if [ "$?" != 0 ]; then
    echo "ERROR: Unable to create virtualenv"
    exit 1
fi

if [ ! -r "./requirements.txt" ]; then
    echo "ERROR: Unable to read requirements.txt"
    exit 1
else
    pip install -r ./requirements.txt
    exit 0
fi
}

delete_venv() {
  source "${VENV_NAME}"/bin/deactivate
  rm -rf "${VENV_NAME}"
}

if [ "$ACTION" == "create" ] ; then
    create_venv
elif [ "$ACTION" == "delete" ] ; then
    delete_venv
}
