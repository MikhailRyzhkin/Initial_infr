#!/bin/bash

# Установка kubeadm kubectl
# Ставим публичный ключ Google Cloud
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

#Добавляем Kubernetes репозиторий и перечитываем их:
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list 
apt-get update

# Устанавливаем и замораживаем версию утилит при последующих обновлениях через пакетный менеджер:
sudo apt-get install -y kubeadm kubectl
sudo apt-mark hold kubeadm kubectl

# Установка gitlab-runner
# Ставим официальный репозиторий gitlab-runner и перечитываем списки репозиторий
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash 
apt-get update

# Установка gitlab-runner
apt-get install gitlab-runner -y