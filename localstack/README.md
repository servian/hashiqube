# Localstack
https://localstack.cloud/

LocalStack provides an easy-to-use test/mocking framework for developing Cloud applications. It spins up a testing environment on your local machine that provides the same functionality and APIs as the real AWS cloud environment.

## Terraform and Localstack
https://github.com/localstack/localstack-pro-samples/blob/master/terraform-resources/test.tf<br />
https://www.terraform.io/docs/providers/aws/guides/custom-service-endpoints.html<br />
https://www.terraform.io<br />
https://localstack.cloud<br />
https://github.com/localstack/localstack<br />
https://github.com/localstack/awscli-local

## Instructions
* Install localstack on your laptop, I just installed it in Vagrant
* Install `awslocal` utility

## Localstack

`vagrant up --provision-with localstack`

## Localstack usage

You should be in the localstack directory
`pwd`
```
/Users/user/workspace/vagrant/localstack
```

### terraform init

```
Initializing the backend...
Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.33.0...
The following providers do not have any version constraints in configuration,
so the latest version was installed.
To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.
* provider.aws: version = "~> 2.33"
Terraform has been successfully initialized!
You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### terraform plan

```
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.
------------------------------------------------------------------------
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
 + create
Terraform will perform the following actions:
 # aws_s3_bucket.localstack-s3-bucket will be created
 + resource "aws_s3_bucket" "localstack-s3-bucket" {
     + acceleration_status         = (known after apply)
     + acl                         = "public-read"
     + arn                         = (known after apply)
     + bucket                      = "localstack-s3-bucket"
     + bucket_domain_name          = (known after apply)
     + bucket_regional_domain_name = (known after apply)
     + force_destroy               = false
     + hosted_zone_id              = (known after apply)
     + id                          = (known after apply)
     + region                      = (known after apply)
     + request_payer               = (known after apply)
     + website_domain              = (known after apply)
     + website_endpoint            = (known after apply)
     + versioning {
         + enabled    = (known after apply)
         + mfa_delete = (known after apply)
       }
   }
Plan: 1 to add, 0 to change, 0 to destroy.
------------------------------------------------------------------------
Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

### terraform apply

```
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
 + create
Terraform will perform the following actions:
 # aws_s3_bucket.localstack-s3-bucket will be created
 + resource "aws_s3_bucket" "localstack-s3-bucket" {
     + acceleration_status         = (known after apply)
     + acl                         = "public-read"
     + arn                         = (known after apply)
     + bucket                      = "localstack-s3-bucket"
     + bucket_domain_name          = (known after apply)
     + bucket_regional_domain_name = (known after apply)
     + force_destroy               = false
     + hosted_zone_id              = (known after apply)
     + id                          = (known after apply)
     + region                      = (known after apply)
     + request_payer               = (known after apply)
     + website_domain              = (known after apply)
     + website_endpoint            = (known after apply)
     + versioning {
         + enabled    = (known after apply)
         + mfa_delete = (known after apply)
       }
   }
Plan: 1 to add, 0 to change, 0 to destroy.
Do you want to perform these actions?
 Terraform will perform the actions described above.
 Only 'yes' will be accepted to approve.
 Enter a value: yes
aws_s3_bucket.localstack-s3-bucket: Creating...
aws_s3_bucket.localstack-s3-bucket: Creation complete after 0s [id=localstack-s3-bucket]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
Now check the assets with aws local inside vagrant
`awslocal s3 ls`
```
2006-02-04 03:45:09 localstack-s3-bucket
```
