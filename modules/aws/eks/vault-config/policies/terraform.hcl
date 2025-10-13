# Manage AWS auth roles
path "auth/aws/role/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# List Policies
path "sys/policies/acl" {
  capabilities = ["list"]
}

# Create and manage ACL policies for AWS
path "sys/policies/acl/aws/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/policy/aws/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Terraform vault provider requirement
path "auth/token/create" {
  capabilities = ["update"]
}
