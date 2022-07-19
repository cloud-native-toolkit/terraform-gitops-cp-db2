resource "random_string" "db2id" {
  numeric = true
  special = false
  upper   = false
  lower   = false
  length  = 4
}

locals {
  name          = "cp-db2"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  #db2instanceid    = timestamp()
  db2instanceid    = "${local.name}-${random_string.db2id.result}"
  dbconnectionhost = "${var.dbconnectionhostprefix}-${local.db2instanceid}-${var.dbconnectionhostsuffix}"
  defaultuserpaswrd=var.defaultuserpwd
  values_content = {
    jobName = "${local.name}-job"
    ConfigmapName = "${local.name}-script-configmap"
    storageClassName = var.storageClass
    namespace = var.namespace
    database_name = var.database_name
    InstanceSecret = local.defaultuserpaswrd
    InstanceType = var.db2instancetype
    InstanceVersion = var.db2instanceversion
    InstanceId = local.db2instanceid
    CPDClusterHost = var.cp4dclusterhost
    DatabaseHost = var.db2host
    pvcsize = var.pvcsize
    operator_namespace = var.cpd_operator_namespace
  }
  layer = "services"
  type  = "base"
  application_branch = "main"
  namespace = var.namespace
  layer_config = var.gitops_config[local.layer]
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.name}' '${local.yaml_dir}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.values_content)
    }
  }
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]

  triggers = {
    name = local.name
    namespace = var.namespace
    yaml_dir = local.yaml_dir
    server_name = var.server_name
    layer = local.layer
    type = local.type
    git_credentials = yamlencode(var.git_credentials)
    gitops_config   = yamlencode(var.gitops_config)
    bin_dir = local.bin_dir
  }

  provisioner "local-exec" {
    command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
      GITOPS_CONFIG   = self.triggers.gitops_config
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --delete --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
      GITOPS_CONFIG   = self.triggers.gitops_config
    }
  }
}




module setup_instance_service_account {
  source = "github.com/cloud-native-toolkit/terraform-gitops-service-account.git"

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  namespace = var.namespace
  name = "db2wh-instance-sa"
  server_name = var.server_name
}

module setup_instance_cpd_rbac {
  source = "github.com/cloud-native-toolkit/terraform-gitops-rbac.git?ref=v1.7.1"

  gitops_config             = var.gitops_config
  git_credentials           = var.git_credentials
  service_account_namespace = var.namespace
  service_account_name      = module.setup_instance_service_account.name
  namespace                 = var.namespace
  rules                     = [
    {
      apiGroups = ["*"]
      resources = ["*"]
      verbs = ["*"]
    }
  ]
  server_name               = var.server_name
  cluster_scope             = false
}

module setup_instance_operator_rbac {
  source = "github.com/cloud-native-toolkit/terraform-gitops-rbac.git?ref=v1.7.1"
  depends_on = [module.setup_instance_cpd_rbac]

  gitops_config             = var.gitops_config
  git_credentials           = var.git_credentials
  service_account_namespace = var.namespace
  service_account_name      = module.setup_instance_service_account.name
  namespace                 = var.cpd_operator_namespace
  rules                     = [
    {
      apiGroups = ["*"]
      resources = ["*"]
      verbs = ["*"]
    }
  ]
  server_name               = var.server_name
  cluster_scope             = false
}
