# =============================================================================
# OUTPUT VALUES
# These outputs provide important information for connecting your application
# =============================================================================

# -----------------------------------------------------------------------------
# AKS Cluster Outputs
# -----------------------------------------------------------------------------
output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.aks_name
}

output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = module.aks.aks_id
}

output "acr_login_server" {
  description = "The login server URL for the Azure Container Registry"
  value       = module.aks.acr_login_server
}

# -----------------------------------------------------------------------------
# Backend VM Connection Info - USE THIS TO CONNECT FRONTEND TO BACKEND
# -----------------------------------------------------------------------------
output "backend_internal_lb_ip" {
  description = "The private IP of the Internal Load Balancer. Use this in your frontend app to connect to the backend."
  value       = module.vm.backend_internal_lb_ip
}

output "vm_name" {
  description = "The name of the backend VM"
  value       = module.vm.vm_name
}

# -----------------------------------------------------------------------------
# Network Outputs
# -----------------------------------------------------------------------------
output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.vnet.vnet_name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = module.vnet.vnet_id
}

# -----------------------------------------------------------------------------
# Key Vault Outputs
# -----------------------------------------------------------------------------
output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = module.keyvault.key_vault_id
}

# -----------------------------------------------------------------------------
# Bastion Outputs
# -----------------------------------------------------------------------------
output "bastion_name" {
  description = "The name of the Azure Bastion host for VM access"
  value       = module.vnet.bastion_name
}

# -----------------------------------------------------------------------------
# Connection Instructions
# -----------------------------------------------------------------------------
output "connection_instructions" {
  description = "Instructions for connecting frontend to backend"
  value       = <<-EOT
    
    ================================================================================
    CONNECTION INSTRUCTIONS
    ================================================================================
    
    Your frontend (AKS) can connect to the backend (VM) using:
    
    Backend Internal LB IP: ${module.vm.backend_internal_lb_ip}
    Backend Port: 3000 (or your configured application_port)
    
    Example connection string for your frontend app:
    BACKEND_URL=http://${module.vm.backend_internal_lb_ip}:3000
    
    To access the VM for management:
    1. Go to Azure Portal → Bastion
    2. Connect to: ${module.vm.vm_name}
    3. Use RDP through Bastion (no public IP needed)
    
    ================================================================================
  EOT
}
