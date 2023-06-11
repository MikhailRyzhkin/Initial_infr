# Подключемся через Terraform к сервисной srv ноде с использованием ключа.
resource "null_resource" "srv" {
  depends_on = [yandex_compute_instance.srv]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.srv.network_interface.0.nat_ip_address
  }

# Устанавливаем на сервисную srv ноду git, gitlab-runner, ansible, jq, kubectl, kubeadm, docker, helm, и создаём папку для бинарного файла terraform.
# https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y git curl ca-certificates curl wget gnupg lsb-release gnome-terminal apt-transport-https gnupg-agent software-properties-common",
      "curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash && apt-get update",
      "sudo apt-get install gitlab-runner pip python3.9 ansible jq -y",
      "curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list && apt-get update",
      "sudo apt-get install kubelet kubeadm kubectl -y",
      "sudo apt-mark hold kubelet kubeadm kubectl",
      "curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null",
      "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main' | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list && apt-get update",
      "curl -fsSL https://get.docker.com | sh",
      "sudo usermod -aG docker $USER",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y",
      "sudo systemctl enable docker.service && sudo systemctl enable containerd.service && sudo systemctl start docker.service && sudo systemctl start containerd.service",
      "sudo apt-get install helm -y",
      "sudo mkdir /usr/bin/hashicorp/",      
    ]
  }

# Копируем в srv ноду для установки бинарные файлы terraform и terragrunt по относительному пути от папки проекта
# https://developer.hashicorp.com/terraform/language/resources/provisioners/file
  provisioner "file" {
    source      = "soft/"
    destination = "/usr/bin/hashicorp"
  }

# Копируем в srv ноду файлы для установки конфига с настройкой зеркала yandex для продуктов hashicorp
  provisioner "file" {
    source      = "configs/.terraformrc"
    destination = "~/.terraformrc"
  }

# Устанавливаем на сервисную srv ноду terraform - делаем исполняемыми скопированные бианрные файлы
  provisioner "remote-exec" {
    inline = [
      "chmod +x /usr/bin/hashicorp/terraform",
      "chmod +x /usr/bin/hashicorp/terragrunt",      
      "sleep 25",
      "echo COMPLETED"
    ]
  }
}
