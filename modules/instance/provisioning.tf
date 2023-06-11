# Подключемся через Terraform к сервисной srv ноде с использованием ключа.
resource "null_resource" "srv" {
  depends_on = [yandex_compute_instance.srv]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.srv.network_interface.0.nat_ip_address
  }


 # Копируем в srv ноду для установки бинарные файлы terraform и terragrunt по относительному пути от папки проекта 
 # https://developer.hashicorp.com/terraform/language/resources/provisioners/file
  provisioner "file" {
    source      = "soft/"
    destination = "/home/ubuntu"
  }

# Копируем в srv ноду файл для установки конфига с настройкой зеркала yandex для продуктов hashicorp
  provisioner "file" {
    source      = "configs/"
    destination = "/home/ubuntu"
  }

# Копируем в srv ноду скрипт для установки gitlab-runner, kubectl, kubeadm, helm 
  provisioner "file" {
    source      = "scripts/"
    destination = "/home/ubuntu"
  }

 # Устанавливаем на сервисную srv ноду terraform - делаем исполняемыми скопированные бинарные файлы. Делаем исполняемым скрипт
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/terraform",
      "chmod +x /home/ubuntu/terragrunt",
      "chmod +x /home/ubuntu/install.sh",      
      "sleep 25",
      "echo COMPLETED+X"
    ]
  }


# Устанавливаем на сервисную srv ноду git, gitlab-runner, ansible, jq, docker, kubeadm, kubectl, gitlab-runner и перекладываем бинарные файлы terraform
# https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y git curl ca-certificates curl gnupg lsb-release gnome-terminal apt-transport-https gnupg-agent software-properties-common",
      "curl -fsSL https://get.docker.com | sh",
      "sudo usermod -aG docker $USER", 
      "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y", 
      "sudo apt-get install ansible jq -y",   
      "sudo cp /home/ubuntu/.terraformrc /root/.terraformrc",
      "sudo cp /home/ubuntu/terraform /bin/terraform",
      "sudo cp /home/ubuntu/terragrunt /bin/terragrunt",
      "sudo /home/ubuntu/install.sh",        
      "sudo systemctl enable docker.service && sudo systemctl enable containerd.service && sudo systemctl start docker.service && sudo systemctl start containerd.service",
      "sleep 25",
      "echo COMPLETED_install"            
    ]
  }
}