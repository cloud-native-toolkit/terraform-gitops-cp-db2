
output "name" {
  description = "The name of the module"
  value       = local.name
  depends_on  = [null_resource.setup_gitops]
}

output "branch" {
  description = "The branch where the module config has been placed"
  value       = local.application_branch
  depends_on  = [null_resource.setup_gitops]
}

output "namespace" {
  description = "The namespace where the module will be deployed"
  value       = local.namespace
  depends_on  = [null_resource.setup_gitops]
}



output "server_name" {
  description = "The server where the module will be deployed"
  value       = var.server_name
  depends_on  = [null_resource.setup_gitops]
}

output "layer" {
  description = "The layer where the module is deployed"
  value       = local.layer
  depends_on  = [null_resource.setup_gitops]
}

output "type" {
  description = "The type of module where the module is deployed"
  value       = local.type
  depends_on  = [null_resource.setup_gitops]
}

output "instanceid" {
  description = "Unique instance ID for each newly created DB2"
  value       = local.db2instanceid
  depends_on  = [null_resource.setup_gitops]
}

output "storageClass" {
  description = "The server where the module will be deployed"
  value       = var.storageClass
  depends_on  = [null_resource.setup_gitops]
}

output "database_name" {
  description = "The server where the module will be deployed"
  value       = var.database_name
  depends_on  = [null_resource.setup_gitops]
}

output "pvcsize" {
  description = "The size of the pvc that needs to be created for db2"
  value       = var.pvcsize
  depends_on  = [null_resource.setup_gitops]
}

output "defaultuserpaswrd" {
  description = "Password of the default user"
  value       = local.defaultuserpaswrd
  depends_on  = [null_resource.setup_gitops]
}

output "db2host" {
  description = "Password of the default user"
  value       = local.db2host
  depends_on  = [null_resource.setup_gitops]
}


