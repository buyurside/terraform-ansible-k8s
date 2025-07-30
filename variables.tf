variable "ve_endpoint" {
  type        = string
  description = "URL сервера API для Proxmox VE (пример: https://host:port/api2/json)"
}

variable "storage_name" {
  type        = string
  description = "Название lvm-раздела, где PVE хранит данные о виртуалках. Например, 'local-lvm' "
}

variable "pve_node" {
  type        = string
  description = "Название PVE-ноды (например, pve01)"
}

variable "template_name" {
  type        = string
  default     = "ubuntu-cloudinit"
  description = "НАЗВАНИЕ темплейта ВМ, который будет клонироваться"
}

variable "ssh_keys" {
  type        = string
  description = "Строка с публичными ssh-ключами"
}

variable "os_username" {
  type        = string
  default     = "user"
  description = "Имя для будущего пользователя"
}

variable "os_password" {
  type        = string
  default     = ""
  description = "Пароль для будущего пользователя"
}

variable "nameserver" {
  type        = string
  description = "Адрес DNS сервера"
}

variable "searchdomain" {
  type        = string
  description = "Доменный суфикс"
}

variable "pve_subnet" {
  type        = string
  default     = "192.168.122"
  description = "Подсеть в Proxmox VE. ПИШЕТСЯ БЕЗ ПОСЛЕДНЕГО ОКТЕТА, то есть: '192.168.0' "
}

variable "pve_subnet_gw" {
  type        = string
  default     = "192.168.122.1"
  description = "Адрес шлюза сети Proxmox VE"
}

variable "disk_size" {
  type        = number
  default     = 10
  description = "Размер основного диска. По умолчанию 10Гб"
}

variable "vm_ip" {
  type        = string
  default     = "192.168.122.101/24"
  description = "Адресс ВМ"
}

variable "vm_id" {
  type        = string
  default     = "101"
  description = "Идентификатор ВМ"
}

variable "vm_name" {
  type        = string
  default     = "vm-01"
  description = "Название ВМ"
}

