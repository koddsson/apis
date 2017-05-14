# APIS.IS

The project is split up into three parts:

The scraping functions:
  `packages/[endpoint]`
The API:
  `functions/[endpoint]`
The routing:
  `infrastructure/[deployment_stage]/[endpoint]`

# TODO
- Document all these decisions.
- Solve documentation
  - Compile from packages
  - Automatic deployment to github pages using `gh-pages`
- Solve dependencies
  - Tests and greenkeeper?
- Solve versioning
- Figure "live" testing
