# Production Environment Variables
environment           = "prod"
location              = "uksouth"
resource_group_name   = "rg-devops-demo-prod"
acr_name              = "devopsdemoacrprod9568"  # Must be globally unique
app_service_plan_name = "asp-devops-demo-prod"
webapp_name           = "devops-demo-webapp-prod"
sku_name              = "P1V2"  # Premium tier for production
image_name            = "demo-app"
image_tag             = "latest"
sp_object_id          = "24925e59-0998-4fde-8495-3a54375020c5"  # Your Terraform Service Principal Object ID
