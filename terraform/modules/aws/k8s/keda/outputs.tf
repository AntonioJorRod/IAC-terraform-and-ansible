output "keda_namespace" {
  description = "Namespace donde se instaló KEDA"
  value       = var.namespace
}

output "keda_release_name" {
  description = "Nombre del release de Helm de KEDA"
  value       = helm_release.keda.name
}
