deploy: git_config lerna_bootstrap lerna_publish apex_deploy terraform_apply

git_config:
	git config --global user.email "ci@circleci.com"
	git config --global user.name "CircleCI"

# Terraform commands
terraform_plan:
	AWS_REGION=eu-west-1 apex infra --env prod plan
terraform_apply:
	AWS_REGION=eu-west-1 apex infra --env prod apply
terraform_destroy:
	AWS_REGION=eu-west-1 apex infra --env prod destroy

# Apex commands
apex_deploy:
	for dir in functions/*; do (cd "\${dir}" && yarn); done
	AWS_REGION=eu-west-1 apex --log-level debug --env prod deploy

# npm commands
lerna_publish:
	npm run publish
lerna_bootstrap:
	npm run bootstrap
test:
	npm test
lint:
	npm run lint
