# Terraform modules repo

## Repo structure

We use the following structure for the modules

```
modules/{provider_name}/{module_name}
```

where:
* provider_name - for what provider this module is developed
* module_name - the name of service this module interact with / main purpose of this module

examples:
```
modules/aws/s3
modules/aws/iam
modules/cloudflare/dns
```

## Versioning

we use github tags in order to have versioning for our modules

the tag format is: `{provider_name}-{module_name}-X.Y.Z`

where:
* provider_name - refer to [Repo structure section](#repo-structure)
* module_name - refer to [Repo structure section](#repo-structure)
* X.Y.Z - according to the [standard](https://semver.org/)
