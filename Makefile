deploy: publish apex_deploy terraform_apply

plan:
	AWS_REGION=eu-west-1 apex infra --env prod plan
apply:
	AWS_REGION=eu-west-1 apex infra --env prod apply
apex_deploy:
	AWS_REGION=eu-west-1 apex --env prod deploy
destroy:
	AWS_REGION=eu-west-1 apex infra --env prod destroy

publish:
	npm run publish
test:
	npm test
lint:
	npm run lint
