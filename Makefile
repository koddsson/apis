plan:
	AWS_REGION=eu-west-1 apex infra --env prod plan
apply:
	AWS_REGION=eu-west-1 apex infra --env prod apply
deploy: apply
	AWS_REGION=eu-west-1 apex --env prod deploy
	./node_modules/.bin/slackcli \
		-u "Deployment bot" \
		-e :robot: \
		-h alerts \
		-m "Just deployed a new version"
destroy:
	AWS_REGION=eu-west-1 apex infra --env prod destroy