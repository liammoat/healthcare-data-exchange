# Swagger File

As part of the API Management, we have a Swagger file that describes the API. This file is used to generate the API documentation and to create the API in the API Management.
The Swagger file is not stored in the repository, but is generated by the CI pipeline and published as an artifact. The file is generated by the `Build and Publish Swagger Docs` job in the CI pipeline and is published as an artifact named `dex-swagger.json`.
The file is then used by the CD pipeline and terraform to create the API in the API Management together with the relevant policies.
In order to generate the swagger file for local testing, you can run the following script:

```bash
bash ./.pipelines/scripts/generate-swagger.sh infrastructure/services/api_management
```

This script will generate the swagger file and store it in the `infrastructure/services/api_management` folder. The file can then be used to create the API in the API Management via terraform.
