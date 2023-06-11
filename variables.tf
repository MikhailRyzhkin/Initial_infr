# Переменная определяющая зону для разворачивания ВМ
variable "zone" {                                                   # Используем переменную для передачи в конфиг инфраструктуры
  description = "Use specific availability zone"                    # Опционально описание переменной
  type        = list(string)                                        # Опционально тип переменной, коллекция последовательностей значения
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-c"] # Опционально значение переменной зоны расположения сервера, перечисленные по порядку для выбора
}

# Переменная определяющая токен подключения к облаку яндекс
variable "yandex_cloud_token" {
  description = "Default cloud token in yandex cloud"
  type        = string
  default     = "y0_AgAAAAAFfnyWAATuwQAAAADa7e5NpRcTw-AOTp-uD3Dtgjazhgdhl1Y"
}

# Переменная определяющая id облака, где развернуть ВМ
variable "yandex_cloud_id" {
  description = "Default cloud ID in yandex cloud"
  type        = string
  default     = "b1gs2cbitd2kpbr5uro2"
}

# Переменная определяющая id папки, где развернуть ВМ
variable "yandex_folder_id" {
  description = "Default folder ID in yandex cloud"
  type        = string
  default     = "b1g2vggdc9elkn49hgus"
}