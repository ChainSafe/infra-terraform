# Changelog

## [0.2.0](https://github.com/ChainSafe/infra-terraform/compare/aws-eks-keycloak-0.1.0...aws-eks-keycloak-0.2.0) (2025-10-16)


### Features

* add OVH vRack Terraform module ([4efea3a](https://github.com/ChainSafe/infra-terraform/commit/4efea3a4fa78fe1710a298a8339f530b3a33970c))
* **eks/ansible-ara, eks/keycloak:** update OAuth2-Proxy and Helm charts configurations ([9035f96](https://github.com/ChainSafe/infra-terraform/commit/9035f96633fce4753daa59aa1fa2e13401da34ae))
* **eks/keycloak:** add Htpasswd integration for OAuth2-Proxy and Vault secrets ([cf4f693](https://github.com/ChainSafe/infra-terraform/commit/cf4f6935db855156110e0c9b9a33943634abed9a))
* **eks/keycloak:** integrate Vault secrets and GitHub OIDC IdP configuration ([3ca905b](https://github.com/ChainSafe/infra-terraform/commit/3ca905be0eb7a1f206ab4784de8b7bd7342fc452))
* **eks/keycloak:** migrate Keycloak to `keycloakx` chart and integrate PostgreSQL operator ([40f59d6](https://github.com/ChainSafe/infra-terraform/commit/40f59d64238cd98f33ea663dd9838f5cbf345dde))
* **eks/security:** remove Dex integration and migrate OAuth2-Proxy to Keycloak ([1f14854](https://github.com/ChainSafe/infra-terraform/commit/1f14854347f728f1b655b35b398dd03d8471760e))


### Bug Fixes

* **eks/keycloak:** correct `oidcIssuerURL` key to `oidc_issuer_url` in OAuth2-Proxy configuration ([6f346cd](https://github.com/ChainSafe/infra-terraform/commit/6f346cdf0529e11eb891b4354ad51c67f52e10a4))

## 0.1.0 (2025-09-09)


### ⚠ BREAKING CHANGES

* Initial release modules

### Features

* Initial release modules ([bc619d7](https://github.com/ChainSafe/infra-terraform/commit/bc619d706ddbd1c27afea994dfeaf69aa429b18b))
