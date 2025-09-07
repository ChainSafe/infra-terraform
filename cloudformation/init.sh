#!/usr/bin/env bash
# AWS_ORG_ID=o-v8wfh67azn
ORG_NAME=chainsafe
ORG_ACCOUNT_ID=905418303280
AWS_REGION=us-east-2
ADMIN_ROLE=AWSReservedSSO_AWSAdministratorAccess_6d35ba7c9e5137e3
export AWS_PAGER=""

aws cloudformation deploy \
  --stack-name init-terraform-roles \
  --parameter-overrides \
    OrganizationName=${ORG_NAME} \
    OrganizationAdminRoleName=${ADMIN_ROLE} \
    DefaultRegion=${AWS_REGION} \
    MasterAccountId=${ORG_ACCOUNT_ID} \
  --capabilities CAPABILITY_NAMED_IAM \
  --disable-rollback \
  --template-file ./init-terraform-roles.yaml

#aws cloudformation update-stack-set \
#  --stack-set-name init-terraform-roles \
#  --parameters \
#    ParameterKey=OrganizationName,ParameterValue=${ORG_NAME} \
#    ParameterKey=MasterAccountId,ParameterValue=${ORG_ACCOUNT_ID} \
#    ParameterKey=DefaultRegion,ParameterValue=${AWS_REGION} \
#    ParameterKey=OrganizationAdminRoleName,ParameterValue=${ADMIN_ROLE} \
#  --capabilities CAPABILITY_NAMED_IAM \
#  --permission-model SERVICE_MANAGED \
#  --auto-deployment Enabled=true,RetainStacksOnAccountRemoval=false \
#  --template-body file://init-terraform-roles.yaml
#
#aws cloudformation update-stack-instances \
#  --stack-set-name init-terraform-roles \
#  --deployment-targets \
#    OrganizationalUnitIds=${AWS_ORG_ID} \
#  --regions "[\"${AWS_REGION}\"]" \
#  --operation-preferences FailureToleranceCount=0,MaxConcurrentCount=1
