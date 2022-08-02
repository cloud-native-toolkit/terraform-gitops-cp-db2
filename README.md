# Cloud Pak DB2 database instance gitops module

Module to populate a gitops repo with the resources necessary to provision a DB2 of DB2WH database instance from Cloud Pak for Data. 

This module requires a cluster that already has [Data Foundation](https://github.com/IBM/automation-data-foundation) and [DB2 Warehouse Service](github.com/cloud-native-toolkit/terraform-gitops-cp-db2wh-service) deployed.

For DB2 Warehouse (`db2wh`) instance types, the module will disable automatic setting of kernel parameters, so that it can deploy on both managed and unmanaged clusters, following the steps listed at https://www.ibm.com/docs/en/cloud-paks/cp-data/4.0?topic=privileges-configuring-db2-warehouse. 

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v12

### Terraform providers

none

## Module dependencies

This module makes use of the output from other modules:

- GitOps - github.com/cloud-native-toolkit/terraform-tools-gitops.git
- Namespace - github.com/cloud-native-toolkit/terraform-gitops-namespace.git
- db2wh-service - github.com/cloud-native-toolkit/terraform-gitops-cp-db2wh-service

## Example usage

```hcl-terraform
module "cp-db2" {
  source = "https://github.com/cloud-native-toolkit/terraform-gitops-cp-db2.git"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = "cp4d"
  kubeseal_cert = module.gitops.sealed_secrets_cert
  storageClass = var.storageClass
  database_name = var.database_name
  pvcsize       = var.pvcsize
  db2instancetype = "db2wh"
}
```

