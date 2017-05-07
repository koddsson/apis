deploy: publish apex_deploy terraform_apply

# Terraform commands
terraform_plan:
	AWS_REGION=eu-west-1 apex infra --env prod plan
terraform_apply:
	AWS_REGION=eu-west-1 apex infra --env prod apply
terraform_destroy:
	AWS_REGION=eu-west-1 apex infra --env prod destroy

# Apex commands
apex_deploy:
	AWS_REGION=eu-west-1 apex --env prod deploy

# npm commands
publish:
	npm run publish
test:
	npm test
lint:
	npm run lint
