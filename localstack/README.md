# Localstack
https://localstack.cloud/

LocalStack provides an easy-to-use test/mocking framework for developing Cloud applications. It spins up a testing environment on your local machine that provides the same functionality and APIs as the real AWS cloud environment.

## Terraform and Localstack
https://www.terraform.io/docs/providers/aws/guides/custom-service-endpoints.html<br />
https://www.terraform.io<br />
https://localstack.cloud<br />
https://github.com/localstack/localstack<br />
https://github.com/localstack/awscli-local

## Instructions
* Install localstack on your laptop, I just installed it in Vagrant
* Install `awslocal` utility

## Localstack

![Localstack](images/localstack.png?raw=true "Localstack")
`vagrant up --provision-with localstack`
```
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 consul-user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 vault-user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 nomad-user.local.dev
==> user.local.dev: Running provisioner: localstack (shell)...
   user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20191024-26526-169g2xr.sh
   user.local.dev: Reading package lists...
   user.local.dev: Building dependency tree...
   user.local.dev:
   user.local.dev: Reading state information...
   user.local.dev: python3-pip is already the newest version (8.1.1-2ubuntu0.4).
   user.local.dev: 0 upgraded, 0 newly installed, 0 to remove and 4 not upgraded.
   user.local.dev: Uninstalling pip-19.3.1:
   user.local.dev:   Successfully uninstalled pip-19.3.1
   user.local.dev: Reading package lists...
   user.local.dev: Building dependency tree...
   user.local.dev:
   user.local.dev: Reading state information...
   user.local.dev: dpkg-preconfigure: unable to re-open stdin: No such file or directory
   user.local.dev: 0 upgraded, 0 newly installed, 1 reinstalled, 0 to remove and 4 not upgraded.
   user.local.dev: Need to get 0 B/109 kB of archives.
   user.local.dev: After this operation, 0 B of additional disk space will be used.
   user.local.dev: (Reading database ...
(Reading database ... 60%v: (Reading database ... 5%
   user.local.dev: (Reading database ... 65%
   user.local.dev: (Reading database ... 70%
   user.local.dev: (Reading database ... 75%
   user.local.dev: (Reading database ... 80%
   user.local.dev: (Reading database ... 85%
   user.local.dev: (Reading database ... 90%
   user.local.dev: (Reading database ... 95%
(Reading database ... 61570 files and directories currently installed.)
   user.local.dev: Preparing to unpack .../python3-pip_8.1.1-2ubuntu0.4_all.deb ...
   user.local.dev: Unpacking python3-pip (8.1.1-2ubuntu0.4) over (8.1.1-2ubuntu0.4) ...
   user.local.dev: Processing triggers for man-db (2.7.5-1) ...
   user.local.dev: Setting up python3-pip (8.1.1-2ubuntu0.4) ...
   user.local.dev: Collecting pip
   user.local.dev:   Using cached https://files.pythonhosted.org/packages/00/b6/9cfa56b4081ad13874b0c6f96af8ce16cfbc1cb06bedf8e9164ce5551ec1/pip-19.3.1-py2.py3-none-any.whl
   user.local.dev: Installing collected packages: pip
   user.local.dev:   Found existing installation: pip 8.1.1
   user.local.dev:     Not uninstalling pip at /usr/lib/python3/dist-packages, outside environment /usr
   user.local.dev: Successfully installed pip-19.3.1
   user.local.dev: Requirement already up-to-date: awscli-local in ./.local/lib/python3.5/site-packages (0.4)
   user.local.dev: Requirement already satisfied, skipping upgrade: awscli in ./.local/lib/python3.5/site-packages (from awscli-local) (1.16.265)
   user.local.dev: Requirement already satisfied, skipping upgrade: localstack-client in ./.local/lib/python3.5/site-packages (from awscli-local) (0.14)
   user.local.dev: Requirement already satisfied, skipping upgrade: docutils<0.16,>=0.10 in ./.local/lib/python3.5/site-packages (from awscli->awscli-local) (0.15.2)
   user.local.dev: Requirement already satisfied, skipping upgrade: colorama<0.4.2,>=0.2.5; python_version != "2.6" and python_version != "3.3" in ./.local/lib/python3.5/site-packages (from awscli->awscli-local) (0.4.1)
   user.local.dev: Requirement already satisfied, skipping upgrade: botocore==1.13.1 in ./.local/lib/python3.5/site-packages (from awscli->awscli-local) (1.13.1)
   user.local.dev: Requirement already satisfied, skipping upgrade: s3transfer<0.3.0,>=0.2.0 in ./.local/lib/python3.5/site-packages (from awscli->awscli-local) (0.2.1)
   user.local.dev: Requirement already satisfied, skipping upgrade: rsa<=3.5.0,>=3.1.2 in ./.local/lib/python3.5/site-packages (from awscli->awscli-local) (3.4.2)
   user.local.dev: Requirement already satisfied, skipping upgrade: PyYAML<5.2,>=3.10; python_version != "2.6" and python_version != "3.3" in ./.local/lib/python3.5/site-packages (from awscli->awscli-local) (5.1.2)
   user.local.dev: Requirement already satisfied, skipping upgrade: boto3 in ./.local/lib/python3.5/site-packages (from localstack-client->awscli-local) (1.10.1)
   user.local.dev: Requirement already satisfied, skipping upgrade: urllib3<1.26,>=1.20; python_version >= "3.4" in ./.local/lib/python3.5/site-packages (from botocore==1.13.1->awscli->awscli-local) (1.25.6)
   user.local.dev: Requirement already satisfied, skipping upgrade: jmespath<1.0.0,>=0.7.1 in ./.local/lib/python3.5/site-packages (from botocore==1.13.1->awscli->awscli-local) (0.9.4)
   user.local.dev: Requirement already satisfied, skipping upgrade: python-dateutil<3.0.0,>=2.1; python_version >= "2.7" in ./.local/lib/python3.5/site-packages (from botocore==1.13.1->awscli->awscli-local) (2.8.0)
   user.local.dev: Requirement already satisfied, skipping upgrade: pyasn1>=0.1.3 in ./.local/lib/python3.5/site-packages (from rsa<=3.5.0,>=3.1.2->awscli->awscli-local) (0.4.7)
   user.local.dev: Requirement already satisfied, skipping upgrade: six>=1.5 in ./.local/lib/python3.5/site-packages (from python-dateutil<3.0.0,>=2.1; python_version >= "2.7"->botocore==1.13.1->awscli->awscli-local) (1.12.0)
   user.local.dev: Requirement already up-to-date: localstack in ./.local/lib/python3.5/site-packages (0.10.4.2)
   user.local.dev: Requirement already satisfied, skipping upgrade: boto3>=1.9.71 in ./.local/lib/python3.5/site-packages (from localstack) (1.10.1)
   user.local.dev: Requirement already satisfied, skipping upgrade: dnspython==1.16.0 in ./.local/lib/python3.5/site-packages (from localstack) (1.16.0)
   user.local.dev: Requirement already satisfied, skipping upgrade: docopt>=0.6.2 in ./.local/lib/python3.5/site-packages (from localstack) (0.6.2)
   user.local.dev: Requirement already satisfied, skipping upgrade: localstack-ext>=0.10.2 in ./.local/lib/python3.5/site-packages (from localstack) (0.10.49)
   user.local.dev: Requirement already satisfied, skipping upgrade: localstack-client>=0.12 in ./.local/lib/python3.5/site-packages (from localstack) (0.14)
   user.local.dev: Requirement already satisfied, skipping upgrade: six>=1.12.0 in ./.local/lib/python3.5/site-packages (from localstack) (1.12.0)
   user.local.dev: Requirement already satisfied, skipping upgrade: subprocess32==3.5.4 in ./.local/lib/python3.5/site-packages (from localstack) (3.5.4)
   user.local.dev: Requirement already satisfied, skipping upgrade: botocore<1.14.0,>=1.13.1 in ./.local/lib/python3.5/site-packages (from boto3>=1.9.71->localstack) (1.13.1)
   user.local.dev: Requirement already satisfied, skipping upgrade: jmespath<1.0.0,>=0.7.1 in ./.local/lib/python3.5/site-packages (from boto3>=1.9.71->localstack) (0.9.4)
   user.local.dev: Requirement already satisfied, skipping upgrade: s3transfer<0.3.0,>=0.2.0 in ./.local/lib/python3.5/site-packages (from boto3>=1.9.71->localstack) (0.2.1)
   user.local.dev: Requirement already satisfied, skipping upgrade: dnslib==0.9.10 in ./.local/lib/python3.5/site-packages (from localstack-ext>=0.10.2->localstack) (0.9.10)
   user.local.dev: Requirement already satisfied, skipping upgrade: pyaes==1.6.0 in ./.local/lib/python3.5/site-packages (from localstack-ext>=0.10.2->localstack) (1.6.0)
   user.local.dev: Requirement already satisfied, skipping upgrade: python-dateutil<3.0.0,>=2.1; python_version >= "2.7" in ./.local/lib/python3.5/site-packages (from botocore<1.14.0,>=1.13.1->boto3>=1.9.71->localstack) (2.8.0)
   user.local.dev: Requirement already satisfied, skipping upgrade: docutils<0.16,>=0.10 in ./.local/lib/python3.5/site-packages (from botocore<1.14.0,>=1.13.1->boto3>=1.9.71->localstack) (0.15.2)
   user.local.dev: Requirement already satisfied, skipping upgrade: urllib3<1.26,>=1.20; python_version >= "3.4" in ./.local/lib/python3.5/site-packages (from botocore<1.14.0,>=1.13.1->boto3>=1.9.71->localstack) (1.25.6)
   user.local.dev: Requirement already up-to-date: flask-cors in /usr/local/lib/python3.5/dist-packages (3.0.8)
   user.local.dev: Requirement already satisfied, skipping upgrade: Flask>=0.9 in /usr/local/lib/python3.5/dist-packages (from flask-cors) (1.1.1)
   user.local.dev: Requirement already satisfied, skipping upgrade: Six in ./.local/lib/python3.5/site-packages (from flask-cors) (1.12.0)
   user.local.dev: Requirement already satisfied, skipping upgrade: itsdangerous>=0.24 in /usr/local/lib/python3.5/dist-packages (from Flask>=0.9->flask-cors) (1.1.0)
   user.local.dev: Requirement already satisfied, skipping upgrade: Jinja2>=2.10.1 in /usr/local/lib/python3.5/dist-packages (from Flask>=0.9->flask-cors) (2.10.3)
   user.local.dev: Requirement already satisfied, skipping upgrade: click>=5.1 in /usr/local/lib/python3.5/dist-packages (from Flask>=0.9->flask-cors) (7.0)
   user.local.dev: Requirement already satisfied, skipping upgrade: Werkzeug>=0.15 in /usr/local/lib/python3.5/dist-packages (from Flask>=0.9->flask-cors) (0.16.0)
   user.local.dev: Requirement already satisfied, skipping upgrade: MarkupSafe>=0.23 in /usr/lib/python3/dist-packages (from Jinja2>=2.10.1->Flask>=0.9->flask-cors) (0.23)
   user.local.dev: localstack_main
   user.local.dev: Error: No such container: localstack_main
   user.local.dev: Starting local dev environment. CTRL-C to quit.
   user.local.dev: ERROR: 'chmod -R 777 "/tmp/localstack"': exit code 1; output: b"chmod: changing permissions of '/tmp/localstack/server.test.pem.key': Operation not permitted\nchmod: changing permissions of '/tmp/localstack/sqs.bd904226.conf': Operation not permitted\nchmod: changing permissions of '/tmp/localstack/server.test.pem.crt': Operation not permitted\nchmod: changing permissions of '/tmp/localstack/server.test.pem': Operation not permitted\n"
   user.local.dev: a9eae55a77b0e465e42f18b057343dc23d3e0e8fa91b2c7340c8db5b3de87d65
   user.local.dev: docker run -it -d -e LOCALSTACK_HOSTNAME="localhost" -e DEFAULT_REGION="us-east-1" -e LOCALSTACK_HOSTNAME="localhost" --rm --privileged --name localstack_main -p 8080:8080 -p 8081:8081  -p 443:443 -p 4567-4607:4567-4607  -v "/tmp/localstack:/tmp/localstack" -v "/var/run/docker.sock:/var/run/docker.sock" -e DOCKER_HOST="unix:///var/run/docker.sock" -e HOST_TMP_FOLDER="/tmp/localstack" "localstack/localstack"
```

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
