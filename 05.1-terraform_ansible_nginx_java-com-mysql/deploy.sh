#!/bin/bash

cd terraform
terraform init
terraform apply -auto-approve

echo  "Aguardando a criação das maquinas ..."
sleep 5

HOST_DNS=$(terraform output | grep 'PUBLIC_DNS=' | awk '{print $1;exit}' | cut -b 13- | sed "s/\",//g")

echo "
[ec2-java]
$HOST_DNS
" > ../ansible/hosts

cd ../ansible

ANSIBLE_HOST_KEY_CHECKING=False USER=user PASSWORD=root DATABASE=SpringWebYoutube ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ~/cert-turma3-clayton-dev.pem
echo  "Abrindo site no navegador"
sleep 10

explorer  "http://$HOST_DNS"

echo  "Acessando via SH"
sleep 5
ssh -i ~/cert-turma3-clayton-dev.pem ubuntu@$HOST_DNS -o ServerAliveInterval=60