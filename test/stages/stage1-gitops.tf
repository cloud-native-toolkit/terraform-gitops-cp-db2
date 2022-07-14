
module "olm" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-olm?ref=v1.3.2"

  cluster_config_file = module.dev_cluster.config_file_path
  cluster_type = module.dev_cluster.platform.type_code
  cluster_version = module.dev_cluster.platform.version
}

module "gitea" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitea?ref=v0.3.6"

  cluster_config_file = module.dev_cluster.config_file_path
  cluster_type = module.dev_cluster.platform.type_code
  instance_name = var.gitea_instance_name
  instance_namespace = module.gitea_namespace.name
  olm_namespace = module.olm.olm_namespace
  operator_namespace = module.olm.target_namespace
  password = var.gitea_password
  username = var.gitea_username
}
module "gitea_namespace" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-namespace?ref=v3.2.3"

  cluster_config_file_path = module.dev_cluster.config_file_path
  create_operator_group = var.gitea_namespace_create_operator_group
  name = var.gitea_namespace_name
}
module "gitops" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitops?ref=v1.20.4"

  branch = var.gitops_repo_branch
  debug = var.debug
  gitea_host = module.gitea.host
  gitea_org = module.gitea.org
  gitea_token = module.gitea.token
  gitea_username = module.gitea.username
  gitops_namespace = var.gitops_repo_gitops_namespace
  public = var.gitops_repo_public
  repo = var.gitops_repo_repo
  sealed_secrets_cert = module.cert.cert
  server_name = var.gitops_repo_server_name
  strict = var.gitops_repo_strict
  type = var.gitops_repo_type
}

resource null_resource gitops_output {
  provisioner "local-exec" {
    command = "echo -n '${module.gitops.config_repo}' > git_repo"
  }

  provisioner "local-exec" {
    command = "echo -n '${module.gitops.config_token}' > git_token"
  }
}
