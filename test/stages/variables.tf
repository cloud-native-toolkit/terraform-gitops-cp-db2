
variable "gitea_namespace_name" {
  type = string
  description = "The value that should be used for the namespace"
  default = "gitea"
}

variable "gitea_namespace_create_operator_group" {
  type = bool
  description = "Flag indicating that an operator group should be created in the namespace"
  default = true
}

variable "gitea_namespace_argocd_namespace" {
  type = string
  description = "The namespace where argocd has been deployed"
  default = "openshift-gitops"
}

variable "gitea_instance_name" {
  type = string
  description = "The name for the instance"
  default = "gitea"
}

variable "gitea_username" {
  type = string
  description = "The username for the instance"
  default = "gitea-admin"
}

variable "gitea_password" {
  type = string
  description = "The password for the instance"
  default = ""
}

variable "gitops_repo_strict" {
  type = bool
  description = "Flag indicating that an error should be thrown if the repo already exists"
  default = false
}
variable "debug" {
  type = bool
  description = "Flag indicating that debug loggging should be enabled"
  default = false
}

variable "gitops_repo_type" {
  type = string
  description = "[Deprecated] The type of the hosted git repository."
  default = ""
}


variable "gitops_repo_repo" {
  type = string
  description = "The short name of the repository (i.e. the part after the org/group name)"
  default = "db2wh-gitops"
}
variable "gitops_repo_branch" {
  type = string
  description = "The name of the branch that will be used. If the repo already exists (provision=false) then it is assumed this branch already exists as well"
  default = "main"
}
variable "gitops_repo_public" {
  type = bool
  description = "Flag indicating that the repo should be public or private"
  default = false
}
variable "gitops_repo_gitops_namespace" {
  type = string
  description = "The namespace where ArgoCD is running in the cluster"
  default = "openshift-gitops"
}
variable "gitops_repo_server_name" {
  type = string
  description = "The name of the cluster that will be configured via gitops. This is used to separate the config by cluster"
  default = "default"
}

variable cluster_username { 
  type        = string
  description = "The username for AWS access"
}

variable "cluster_password" {
  type        = string
  description = "The password for AWS access"
}

variable "server_url" {
  type        = string
}

variable "bootstrap_prefix" {
  type = string
  default = ""
}

variable "namespace" {
  type        = string
  description = "Namespace for tools"
}


variable "cpd_namespace" {
  type        = string
  description = "Namespace for cpd services"
  default = "cp4d"
}

variable "common_services_namespace" {
  type        = string
  description = "Namespace for cp4d common services"
  default = "ibm-common-services"
}

variable "operator_namespace" {
  type        = string
  description = "Namespace for cp4d operators"
  default = "cpd-operators"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = ""
}

variable "cluster_type" {
  type        = string
  description = "The type of cluster that should be created (openshift or kubernetes)"
}

variable "cluster_exists" {
  type        = string
  description = "Flag indicating if the cluster already exists (true or false)"
  default     = "true"
}

variable "git_token" {
  type        = string
  description = "Git token"
}

variable "git_host" {
  type        = string
  default     = "github.com"
}

variable "git_type" {
  default = "github"
}

variable "git_org" {
  default = "cloud-native-toolkit-test"
}

variable "git_repo" {
  default = "git-module-test"
}

variable "gitops_namespace" {
  default = "openshift-gitops"
}

variable "git_username" {
}

variable "kubeseal_namespace" {
  default = "sealed-secrets"
}


variable "storageClass" {
  type        = string
  description = "The name of the server"
  default     = "ocs-storagecluster-cephfs"
  #default     = "portworx-db2-rwx-sc"
}

variable "database_name" {
  type        = string
  description = "The name of the database to be created"
  default     = "db2wh"
}

variable "pvcsize" {
  type        = string
  description = "The size of the pvc that needs to be created"
  default     = 100
}

resource null_resource write_namespace {
  provisioner "local-exec" {
    command = "echo -n '${var.cpd_namespace}' > .cpd_namespace"
  }
}


