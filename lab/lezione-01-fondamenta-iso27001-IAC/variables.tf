variable "aws_region" {
  description = "Regione AWS (finta, floci la ignora ma il provider la richiede)."
  type        = string
  default     = "eu-west-1"
}

variable "floci_endpoint" {
  description = "Endpoint di floci (LocalStack-compatibile)."
  type        = string
  default     = "http://localhost:4566"
}

variable "bucket_name" {
  description = "Nome del bucket S3 di NuvolaSoft."
  type        = string
  default     = "nuvolasoft-dati-clienti"
}

variable "iam_user_name" {
  description = "Utente IAM operativo di NuvolaSoft."
  type        = string
  default     = "mario.rossi"
}

variable "ssm_param_name" {
  description = "Nome del parametro SSM che contiene la password del DB."
  type        = string
  default     = "/nuvolasoft/db-password"
}

variable "ssm_param_value" {
  description = "Valore del segreto (didattico, volutamente hardcoded)."
  type        = string
  default     = "SuperSegreta123!"
  sensitive   = true
}
