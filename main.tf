# Документация по провайдеру: https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs#configuration-reference
# Настраиваем the Yandex.Cloud provider
# Данные для подключения к провайдеру
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">=0.84.0"
    }
  }
}

provider "yandex" {
  token     = var.yandex_cloud_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = var.zone[0]
}

# Создаём сеть кластера kubernetes
resource "yandex_vpc_network" "k8s-network" {
  name = "k8s-network"
}

# Создаём локальную сеть между нодами - ВМ
resource "yandex_vpc_subnet" "k8s-subnet-1" {
  name           = "k8s-subnet-1"
  zone           = var.zone[0]
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}


# Создание сервисной ВМ и развертывание с неё kubernetes кластера согласно вложенного модуля
module "kubernetes_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.k8s-subnet-1.id
  }