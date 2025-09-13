output "storageclass_name" {
  description = "Nombre del StorageClass creado"
  value       = kubernetes_storage_class.this.metadata[0].name
}
