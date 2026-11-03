locals {
  cloudflare_ips = concat(
    compact([for cidr in split("\n", data.http.cloudflare_ips_v4.response_body) : trimspace(cidr)]),
    compact([for cidr in split("\n", data.http.cloudflare_ips_v6.response_body) : trimspace(cidr)]),
  )
}
