
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
  sensitive   = true
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}

variable "cpd_namespace" {
  type        = string
  description = "cpd namespace"
  default     = "gitops-cp4d-instance"
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

variable "storageClass" {
  type        = string
  description = "The name of the server"
  default     = "portworx-db2-rwx-sc"
}

variable "database_name" {
  type        = string
  description = "The name of the database to be created"
  default     = "OMS_DB"
}

variable "db2instancetype" {
  type        = string
  description = "type of db2 intance to be created - db2oltp of db2wh"
  default     = "db2oltp"
}

variable "db2instanceversion" {
  type        = string
  description = "version of the DB2 instance"
  default     = "11.5.5.0-x86_64"
}

variable "defaultuserpwd" {
  type        = string
  description = "Password of the default user"
  default     = "db2password"
}

variable "db2instanceid" {
  type        = string
  description = "Unique instance ID for each newly created DB2"
  default     = "98765432129"
}






