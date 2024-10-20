variable "aws_region" {
  description = "Region AWS, w którym będzie uruchomiona instancja"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Nazwa profilu AWS do użycia"
  type        = string
}

variable "instance_type" {
  description = "Typ instancji EC2"
  type        = string
  default     = "t2.large"
}

variable "key_name" {
  description = "passkey"
  type        = string
}

variable "public_key_path" {
  description = "Ścieżka do pliku z publicznym kluczem SSH"
  type        = string
}

variable "security_group_name" {
  description = "Nazwa grupy zabezpieczeń"
  type        = string
  default     = "elk-security-group"
}

variable "allowed_ssh_ip" {
  description = "Adres IP, z którego będzie dozwolony dostęp przez SSH"
  type        = string
  default     = "0.0.0.0/0" # zmienione na 0 na gihuba normalnie mój adres 
}
