plan:
	AWS_REGION=eu-west-1 apex infra --env prod plan
apply:
	AWS_REGION=eu-west-1 apex infra --env prod apply
publish:
	npm run publish
deploy: publish apply
	AWS_REGION=eu-west-1 apex --env prod deploy
destroy:
	AWS_REGION=eu-west-1 apex infra --env prod destroy
test:
	npm test
lint:
	npm run lint
