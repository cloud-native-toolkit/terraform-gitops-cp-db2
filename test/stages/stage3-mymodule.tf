module "gitops_module" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = "gitops-cp4d-instance"
  kubeseal_cert = module.gitops.sealed_secrets_cert
 

}
