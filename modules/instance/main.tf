data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}

# Compute instance for service
# Создаём ВМ - srv сервисную ноду, с которой будет просиходить развёртывание кластера k8s, мониторинг, логирование и процессы CI/CD
resource "yandex_compute_instance" "srv" { 
  name     = "srv"
  hostname = "srv"

  resources {
    cores  = 4
    memory = 12
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

# SSH ключ для доступа к ВМ - нодам. Ключи создаём без пароля, Terraform не умеет работать с парольными ключами.
# Ключ в данном случае подбираем уже готовый с нашего ПК по адресу: /home/mikhail/.ssh/
  metadata = {
    ssh-keys = "${var.ssh_credentials.user}:${file(var.ssh_credentials.pub_key)}"
  }

}