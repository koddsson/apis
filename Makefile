git_config:
	git config --global user.email "ci@circleci.com"
	git config --global user.name "CircleCI"

# Terraform commands
terraform_plan:
	AWS_REGION=eu-west-1 apex infra --env $$ENVIRONMENT plan
terraform_apply:
	if [ "$${CIRCLE_BRANCH}" = "production" ]; then
		AWS_REGION=eu-west-1 apex infra --env production apply
	else	
		AWS_REGION=eu-west-1 apex infra --env staging apply
	fi
terraform_destroy:
	AWS_REGION=eu-west-1 apex infra --env $$ENVIRONMENT destroy

# Apex commands
apex_deploy:
	for dir in functions/*; do (cd "$$dir" && yarn); done
	AWS_REGION=eu-west-1 apex --log-level debug --env $$ENVIRONMENT deploy

# npm commands
lerna_publish: lerna_bootstrap
	npm run publish -- $$FLAGS
lerna_bootstrap:
	npm run bootstrap
test:
	npm test
lint:
	npm run lint
npm_upgrade:
	find . -iname package.json -not -path "**/node_modules/**" -execdir yarn upgrade \;