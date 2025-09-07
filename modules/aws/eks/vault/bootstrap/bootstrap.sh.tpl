#!/bin/sh
if [ "$VAULT_K8S_POD_NAME" = "vault-server-0" ]; then
  sleep 10
  if vault operator init -status; then
    echo "Vault is already initialized"
  else
    OUTPUT=/tmp/output.txt
    JQ=/tmp/jq
    wget -q https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-arm64 -O /tmp/jq
    chmod +x /tmp/jq

    vault operator init \
      -recovery-shares=5 \
      -recovery-threshold=3 -format json > "$${OUTPUT}"
    root_token=$(/tmp/jq -r '.root_token' "$${OUTPUT}")
    echo "Token: $${root_token}"

    sleep 10
    vault login -no-print "$${root_token}"
    vault secrets enable -version=2 -path=infra kv
    vault kv put infra/root_token "@$${OUTPUT}"
    rm -f /tmp/jq "$${OUTPUT}"

    vault policy write terraform /vault/userconfig/terraform-policy.hcl
    vault policy write admins /vault/userconfig/admin-policy.hcl

    vault auth enable aws
    vault write auth/aws/config/sts/${aws_account_id} \
      account_id=${aws_account_id} \
      external_id=terraform \
      sts_role=${sts_role}

    vault write auth/aws/role/terraform \
      auth_type=iam \
      bound_iam_principal_arn=arn:aws:iam::${aws_account_id}:role/${terraform_role}-management \
      policies=terraform,admins \
      ttl=1h \
      max_ttl=1h
  fi
fi
