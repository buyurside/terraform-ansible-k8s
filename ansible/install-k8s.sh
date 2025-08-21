#!/usr/bin/env bash

set -e

ansible-playbook -i ./inventory/ basic-utils.yml
ansible-playbook -i ./inventory/ k8s-install-dependencies.yml

