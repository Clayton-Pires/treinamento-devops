#!/bin/bash

ANSIBLE_HOST_KEY_CHECKING=False  ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ~/cert-turma3-clayton-dev.pem