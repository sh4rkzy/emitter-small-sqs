include .env

TERRAFORM_DIR=terraform/development

infra-init:
	terraform -chdir=$(TERRAFORM_DIR) init

infra-plan:
	TF_VAR_aws_region=$(AWS_REGION) \
	TF_VAR_aws_access_key=$(AWS_ACCESS_KEY_ID) \
	TF_VAR_aws_secret_key=$(AWS_SECRET_ACCESS_KEY) \
	terraform -chdir=$(TERRAFORM_DIR) plan

infra-up:
	TF_VAR_aws_region=$(AWS_REGION) \
	TF_VAR_aws_access_key=$(AWS_ACCESS_KEY_ID) \
	TF_VAR_aws_secret_key=$(AWS_SECRET_ACCESS_KEY) \
	terraform -chdir=$(TERRAFORM_DIR) apply -auto-approve

infra-destroy:
	TF_VAR_aws_region=$(AWS_REGION) \
	TF_VAR_aws_access_key=$(AWS_ACCESS_KEY_ID) \
	TF_VAR_aws_secret_key=$(AWS_SECRET_ACCESS_KEY) \
	terraform -chdir=$(TERRAFORM_DIR) destroy -auto-approve
