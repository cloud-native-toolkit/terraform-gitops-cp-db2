module "cp4d_deployer" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cp4d-deployer"

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  server_name = var.server_name
  namespace = var.namespace
  kubeseal_cert = var.kubeseal_cert

  entitlement_key = var.entitlement_key
  cluster_name = var.cluster_name
  cluster_ingress = var.ingress_subdomain
  deployer_storage_class = var.storage_class

  install_db2 = true
}
