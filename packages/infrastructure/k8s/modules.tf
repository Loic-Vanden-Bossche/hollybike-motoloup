module "frontend" {
  source = "./frontend"

  namespace          = kubernetes_namespace.hollybike.metadata[0].name
  image = lower(var.frontend_image)
  domain             = "${var.frontend_subdomain}.${var.base_domain}"
  docker_secret_name = data.kubernetes_secret.image_pull.metadata[0].name
}

module "backend" {
  source = "./backend"

  namespace                         = kubernetes_namespace.hollybike.metadata[0].name
  image = lower(var.backend_image)
  domain                            = "${var.backend_subdomain}.${var.base_domain}"
  database_url                      = module.database.url
  database_username                 = var.database_username
  database_password                 = var.database_password
  mapbox_public_access_token_secret = var.mapbox_public_access_token_secret
  security_audience                 = "${var.frontend_subdomain}.${var.base_domain}"
  security_realm                    = var.security_realm
  security_secret                   = var.security_secret
  storage_s3_bucket_name            = var.storage_s3_bucket_name
  storage_s3_password               = var.storage_s3_password
  storage_s3_url                    = module.s3.url
  storage_s3_username               = var.storage_s3_username
  docker_secret_name                = data.kubernetes_secret.image_pull.metadata[0].name
}

module "database" {
  source = "./database"

  namespace         = kubernetes_namespace.hollybike.metadata[0].name
  database_username = var.database_username
  database_password = var.database_password
  database_name     = var.database_name
}

module "s3" {
  source = "./s3"

  namespace   = kubernetes_namespace.hollybike.metadata[0].name
  username    = var.storage_s3_username
  password    = var.storage_s3_password
  bucket_name = var.storage_s3_bucket_name
}

module "action_runners" {
  source = "./action-runners"

  repository_name    = var.repository_name
  docker_secret_name = data.kubernetes_secret.image_pull.metadata[0].name
}