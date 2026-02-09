# Development Environment Variables
environment           = "dev"
location              = "eastus"  # Change to your preferred region
resource_group_name   = "rg-devops-demo-dev"
acr_name              = "devopsdemoacrdev9578"  # Must be globally unique
app_service_plan_name = "asp-devops-demo-dev"
webapp_name           = "devops-demo-webapp-dev"
sku_name              = "B1"  # Basic tier
image_name            = "demo-app"
image_tag             = "latest"
sp_object_id          = "24925e59-0998-4fde-8495-3a54375020c5"  # Your Terraform Service Principal Object ID
