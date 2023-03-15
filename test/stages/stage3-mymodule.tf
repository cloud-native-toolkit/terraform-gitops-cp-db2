module "gitops_module" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  kubeseal_cert = module.gitops.sealed_secrets_cert

  storage_class = module.storage_manager.rwx_storage_class
  storage_class = module.storage_manager.rwx_storage_class
  ingress_subdomain = module.dev_cluster.platform.ingress
  cluster_name = module.dev_cluster.name
  entitlement_key = var.cp_entitlement_key
}
