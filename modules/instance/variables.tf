# Переменная определяющая зону для разворачивания ВМ
variable "zone" {                                                   # Используем переменную для передачи в конфиг инфраструктуры
  description = "Use specific availability zone"                    # Опционально описание переменной
  type        = list(string)                                        # Опционально тип переменной, коллекция последовательностей значения
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-c"] # Опционально значение переменной зоны расположения сервера, перечисленные по порядку для выбора
}

# Указываем какой имидж ОС использовать
variable "instance_family_image" {
  description = "Instance image"
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "vpc_subnet_id" {
  description = "VPC subnet network id"
  type        = string
}

# Указываем где и какой ключ взять
variable "ssh_credentials" {
  description = "Credentials for connect to instances"
  type        = object({
    user        = string
    private_key = string
    pub_key     = string
  })
  default     = {
    user        = "ubuntu"
    private_key = "/home/mikhail/.ssh/mikhail-skillfactory"
    pub_key     = "/home/mikhail/.ssh/mikhail-skillfactory.pub"
  }
}
