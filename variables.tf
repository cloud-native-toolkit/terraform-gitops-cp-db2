
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

variable "storage_class" {
  type        = string
  description = "The RWX/RWO Storage Class needed to create db2"
}

variable "ingress_subdomain" {
  type        = string
  description = "The ingress subdomain of the cluster"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster where db2 will be installed"
}

variable "entitlement_key" {
  type        = string
  description = "Cloud Pak entitlement key"
}
