module "db2wh" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cp-db2wh-service.git"

  gitops_config            = module.gitops.gitops_config
  git_credentials          = module.gitops.git_credentials
  server_name              = module.gitops.server_name
  namespace                = module.gitops_namespace.name
  kubeseal_cert            = module.gitops.sealed_secrets_cert

  operator_namespace= var.operator_namespace
  cpd_namespace = var.cpd_namespace
  common_services_namespace = var.common_services_namespace

}