output "url" {
  description = "Urls to services"
  value = {
    ansible = "https://${local.awx_dns}"
    ara     = "https://${local.ara_dns}"
  }
}
