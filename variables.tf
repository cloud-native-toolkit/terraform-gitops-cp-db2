
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
  description = "Namespace where cp4d is provisioned and where the db2 will be created"
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
  description = "The RWX/RWO Storage Class needed to create db2"
}

variable "database_name" {
  type        = string
  description = "The name of the database to be created"
}

variable "db2instancetype" {
  type        = string
  description = "type of db2 intance to be created - db2oltp of db2wh"
  default     = "db2oltp"
}

variable "db2instanceversion" {
  type        = string
  description = "version of the DB2 instance"
  default     = "11.5.7.0-x86_64"
}

variable "defaultuserpwd" {
  type        = string
  description = "Password of the default user"
  default     = "db2password"
}
variable "cp4dclusterhost" {
  type        = string
  description = "The service name for cp4d"
  default     = "https://ibm-nginx-svc"
}


variable "db2host" {
  type        = string
  description = "The https service name for database"
  default     = "https://database-core-svc:3025"
}

variable "pvcsize" {
  type        = string
  description = "The size of the pvc that needs to be created for db2"
}

variable "dbconnectionhostprefix" {
  type        = string
  description = "Prefix of the db2 connection host"
  default     = "c-db2oltp"
}

variable "dbconnectionhostsuffix" {
  type        = string
  description = "Suffix of the db2 connection host"
  default     = "db2u-engn-svc"
}


variable "cpd_operator_namespace" {
  type        = string
  description = "Namespace for cpd commmon services"
  default = "cpd-operators"
}










