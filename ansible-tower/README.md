# Ansible Tower
## AWX Ansible Tower
https://github.com/ansible/awx <br />
https://www.ansible.com/blog/ansible-tower-feature-spotlight-custom-credentials <br />
https://github.com/ybalt/ansible-tower <br />
https://www.ansible.com/products/tower <br />
https://www.ansible.com/ <br />

## About
AWX provides a web-based user interface, REST API, and task engine built on top of Ansible. It is one of the upstream projects for Red Hat Ansible Automation Platform.

To install AWX, please view the Install guide https://github.com/ansible/awx/blob/devel/INSTALL.md

To learn more about using AWX, and Tower, view the Tower docs site http://docs.ansible.com/ansible-tower/index.html

With Red Hat® Ansible® Tower you can centralize and control your IT infrastructure with a visual dashboard, role-based access control, job scheduling, integrated notifications and graphical inventory management. Easily embed Ansible Tower into existing tools and processes with REST API and CLI.

## Provision

`vagrant up --provision-with basetools,docsify,docker,minikube,ansible-tower`

```
Bringing machine 'hashiqube0.service.consul' up with 'virtualbox' provider...
==> hashiqube0.service.consul: Importing base box 'ubuntu/bionic64'...
==> hashiqube0.service.consul: Matching MAC address for NAT networking...
==> hashiqube0.service.consul: Checking if box 'ubuntu/bionic64' version '20210623.0.0' is up to date...
==> hashiqube0.service.consul: Setting the name of the VM: hashiqube_hashiqube0serviceconsul_1630622011577_474
==> hashiqube0.service.consul: Clearing any previously set network interfaces...
==> hashiqube0.service.consul: Preparing network interfaces based on configuration...
    hashiqube0.service.consul: Adapter 1: nat
    hashiqube0.service.consul: Adapter 2: hostonly
==> hashiqube0.service.consul: Forwarding ports...
    hashiqube0.service.consul: 22 (guest) => 2255 (host) (adapter 1)
    hashiqube0.service.consul: 3000 (guest) => 3000 (host) (adapter 1)
    hashiqube0.service.consul: 9090 (guest) => 9090 (host) (adapter 1)
    hashiqube0.service.consul: 8200 (guest) => 8200 (host) (adapter 1)
...
    hashiqube0.service.consul: Status: Downloaded newer image for redis:latest
    hashiqube0.service.consul: Pulling postgres (postgres:12)...
    hashiqube0.service.consul: 12: Pulling from library/postgres
    hashiqube0.service.consul: Digest: sha256:1cb8f7fc2e6745ef577640de1c9fde04ff9498a7e0d067f1b8e6890ad4ba5073
    hashiqube0.service.consul: Status: Downloaded newer image for postgres:12
    hashiqube0.service.consul: Pulling receptor-hop (quay.io/project-receptor/receptor:latest)...
    hashiqube0.service.consul: latest: Pulling from project-receptor/receptor
    hashiqube0.service.consul: Digest: sha256:3b1ec7a75962bc27891af7e87f60df5393f219d82484630cb1c7cf10202af369
    hashiqube0.service.consul: Status: Downloaded newer image for quay.io/project-receptor/receptor:latest
    hashiqube0.service.consul: Creating tools_redis_1 ...
    hashiqube0.service.consul: Creating tools_postgres_1 ...
    hashiqube0.service.consul: Creating tools_postgres_1 ... done
    hashiqube0.service.consul: Creating tools_redis_1    ... done
    hashiqube0.service.consul: Creating tools_awx_1      ...
    hashiqube0.service.consul: Creating tools_awx_1      ... done
    hashiqube0.service.consul: Creating tools_receptor_hop ...
    hashiqube0.service.consul: Creating tools_receptor_hop ... done
    hashiqube0.service.consul: Creating tools_receptor_1   ...
    hashiqube0.service.consul: Creating tools_receptor_2   ...
    hashiqube0.service.consul: Creating tools_receptor_2   ... done
    hashiqube0.service.consul: Creating tools_receptor_1   ... done
    hashiqube0.service.consul: ++++ Running docker exec tools_awx_1 make clean-ui ui-devel
    hashiqube0.service.consul: rm -rf node_modules
    hashiqube0.service.consul: rm -rf awx/ui/node_modules
    hashiqube0.service.consul: rm -rf awx/ui/build
    hashiqube0.service.consul: rm -rf awx/ui/src/locales/_build
    hashiqube0.service.consul: rm -rf awx/ui/.ui-built
    hashiqube0.service.consul: NODE_OPTIONS=--max-old-space-size=4096 npm --prefix awx/ui --loglevel warn ci
    hashiqube0.service.consul:
    hashiqube0.service.consul: added 2316 packages, and audited 2317 packages in 2m
    hashiqube0.service.consul: 7 packages are looking for funding
    hashiqube0.service.consul:   run `npm fund` for details
    hashiqube0.service.consul:
    hashiqube0.service.consul: 9 moderate severity vulnerabilities
    hashiqube0.service.consul:
    hashiqube0.service.consul: To address all issues (including breaking changes), run:
    hashiqube0.service.consul:   npm audit fix --force
    hashiqube0.service.consul:
    hashiqube0.service.consul: Run `npm audit` for details.
    hashiqube0.service.consul: npm
    hashiqube0.service.consul:  notice
    hashiqube0.service.consul: npm
    hashiqube0.service.consul: notice
    hashiqube0.service.consul:  New minor version of npm available! 7.20.3 -> 7.22.0
    hashiqube0.service.consul: npm
    hashiqube0.service.consul:
    hashiqube0.service.consul: notice
    hashiqube0.service.consul:  Changelog: <https://github.com/npm/cli/releases/tag/v7.22.0>
    hashiqube0.service.consul: npm
    hashiqube0.service.consul:
    hashiqube0.service.consul: notice
    hashiqube0.service.consul:  Run `npm install -g npm@7.22.0` to update!
    hashiqube0.service.consul: npm
    hashiqube0.service.consul:
    hashiqube0.service.consul: notice
    hashiqube0.service.consul:
    hashiqube0.service.consul: make[1]: Entering directory '/awx_devel'
    hashiqube0.service.consul: python3.8 tools/scripts/compilemessages.py
    hashiqube0.service.consul: processing file django.po in /awx_devel/awx/locale/en-us/LC_MESSAGES
    hashiqube0.service.consul:
    hashiqube0.service.consul: processing file django.po in /awx_devel/awx/locale/fr/LC_MESSAGES
    hashiqube0.service.consul:
    hashiqube0.service.consul: processing file django.po in /awx_devel/awx/locale/zh/LC_MESSAGES
    hashiqube0.service.consul:
    hashiqube0.service.consul: processing file django.po in /awx_devel/awx/locale/ja/LC_MESSAGES
    hashiqube0.service.consul:
    hashiqube0.service.consul: processing file django.po in /awx_devel/awx/locale/nl/LC_MESSAGES
    hashiqube0.service.consul:
    hashiqube0.service.consul: processing file django.po in /awx_devel/awx/locale/es/LC_MESSAGES
    hashiqube0.service.consul: npm --prefix awx/ui --loglevel warn run compile-strings
    hashiqube0.service.consul:
    hashiqube0.service.consul: > compile-strings
    hashiqube0.service.consul: > lingui compile
    hashiqube0.service.consul: Compiling message catalogs…
    hashiqube0.service.consul: Done!
    hashiqube0.service.consul: npm --prefix awx/ui --loglevel warn run build
    hashiqube0.service.consul:
    hashiqube0.service.consul: > build
    hashiqube0.service.consul: > INLINE_RUNTIME_CHUNK=false react-scripts build
    hashiqube0.service.consul: Creating an optimized production build...

    hashiqube0.service.consul: Compiled successfully.
    hashiqube0.service.consul:
    hashiqube0.service.consul: File sizes after gzip:
    hashiqube0.service.consul:   604.81 KB  build/static/js/2.815e5b58.chunk.js
    hashiqube0.service.consul:   279.62 KB  build/static/js/main.020cd60d.chunk.js
    hashiqube0.service.consul:   74.22 KB   build/static/css/2.e1a87a1d.chunk.css
    hashiqube0.service.consul:   49.78 KB   build/static/js/9.3530b46c.chunk.js
    hashiqube0.service.consul:   41.79 KB   build/static/js/6.c63a2fbd.chunk.js
    hashiqube0.service.consul:   38.5 KB    build/static/js/5.3180cbb2.chunk.js
    hashiqube0.service.consul:   38.11 KB   build/static/js/8.3dc1f177.chunk.js
    hashiqube0.service.consul:   36.98 KB   build/static/js/4.4e3760ac.chunk.js
    hashiqube0.service.consul:   36.62 KB   build/static/js/7.0eb36b20.chunk.js
    hashiqube0.service.consul:   25 KB      build/static/js/3.ae40d317.chunk.js
    hashiqube0.service.consul:   1.22 KB    build/static/js/runtime-main.49c4d4eb.js
    hashiqube0.service.consul:   196 B      build/static/css/main.e189280d.chunk.css
    hashiqube0.service.consul: The project was built assuming it is hosted at /.
    hashiqube0.service.consul: You can control this with the homepage field in your package.json.
    hashiqube0.service.consul: The build folder is ready to be deployed.
    hashiqube0.service.consul: You may serve it with a static server:
    hashiqube0.service.consul:   npm install -g serve
    hashiqube0.service.consul:   serve -s build
    hashiqube0.service.consul:
    hashiqube0.service.consul: Find out more about deployment here:
    hashiqube0.service.consul:
    hashiqube0.service.consul:   https://cra.link/deployment
    hashiqube0.service.consul: mkdir -p awx/public/static/css
    hashiqube0.service.consul: mkdir -p awx/public/static/js
    hashiqube0.service.consul: mkdir -p awx/public/static/media
    hashiqube0.service.consul: cp -r awx/ui/build/static/css/* awx/public/static/css
    hashiqube0.service.consul: cp -r awx/ui/build/static/js/* awx/public/static/js
    hashiqube0.service.consul: cp -r awx/ui/build/static/media/* awx/public/static/media
    hashiqube0.service.consul: touch awx/ui/.ui-built
    hashiqube0.service.consul: make[1]: Leaving directory '/awx_devel'
    hashiqube0.service.consul: ++++ Create superuser for AWX and setting password
    hashiqube0.service.consul: CommandError: Error: That username is already taken.
    hashiqube0.service.consul: Password updated
    hashiqube0.service.consul: ++++ Loading AWX demo data
    hashiqube0.service.consul: (changed: False)
    hashiqube0.service.consul: ++++ Done
    hashiqube0.service.consul: ++++ AWX https://10.9.99.10:8043 and login with Username: admin and Password: password
```

## Summary
After provision, you can access AWX Ansible Tower https://10.9.99.10:8043/ and login with User: __admin__ and Password: __password__
![Ansible Tower](images/ansible-tower.png?raw=true "Ansible Tower")

## Run a playbook
In order to run a playbook, we have to do a few things, we are going to login to AWX Ansible Tower
Once logged in you will see this page

![Ansible Tower](images/ansible-tower-logged-in.png?raw=true "Ansible Tower")

## Add a project
No we can add a project, click on Projects in the menue on the left and add a new project, here is an example 
You can use my example repository https://github.com/star3am/ansible-role-example-role.git For the Source Control URL
![Ansible Tower](images/ansible-tower-add-project.png?raw=true "Ansible Tower")

## Add a Credential
Navigate to Credentials in the left menue and add a new Credential of type "Machine" select the default organisation and add username __vagrant__ and password __vagrant__
Ansible Tower will use these credentials to login to the Hashiqube VM when we run a job template.
![Ansible Tower](images/ansible-tower-add-credentialt.png?raw=true "Ansible Tower")

## Add Inventory
Now let's add an Inventory, we will need this when we create the Job Template
Click on Inventories on the menue in the left and add a new Inventory.
![Ansible Tower](images/ansible-tower-add-inventory.png?raw=true "Ansible Tower")

## Add a Template
Next we are going to add a Job Template, navigate to Templates in the menue on the left and add a new Job Template
Use the Inventory we created for Vagrant and the Project we created earlier. 

Select __site.yml__ for the Playbook.

Select the vagrant Credential we created earlier. 
![Ansible Tower](images/ansible-tower-add-template.png?raw=true "Ansible Tower")

Be sure to scroll down and select: 
- Privilege Escalation
- Provisioning Callbacks

Also supply a random string which we will use as the __Host Config Key__ `UL3H6uRtDozHA13trZudrUwUPBw4rSo7rRvi`
![Ansible Tower](images/ansible-tower-add-template-more.png?raw=true "Ansible Tower")

## Trigger a Run
Now we can login to Hashiqube and use this Callback to trigger an Ansible Run, let's do that
- SSH into Hashiqube by doing `vagrant ssh` in the project folder

![Ansible Tower](images/vagrant-ssh.png?raw=true "Ansible Tower")

Now let's use our Callback URL and the Host Config Key to trigger a run using Curl

__vagrant@hashiqube0:~$__ `curl -s -i -X POST -H Content-Type:application/json --data '{"host_config_key": "UL3H6uRtDozHA13trZudrUwUPBw4rSo7rRvi"}' https://10.9.99.10:8043/api/v2/job_templates/9/callback/ -v -k`
```
*   Trying 10.9.99.10...
* TCP_NODELAY set
* Connected to 10.9.99.10 (10.9.99.10) port 8043 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Client hello (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* ALPN, server accepted to use http/1.1
* Server certificate:
*  subject: C=US; ST=North Carolina; L=Durham; O=Ansible; OU=AWX Development; CN=awx.localhost
*  start date: Sep  2 22:46:29 2021 GMT
*  expire date: Sep  2 22:46:29 2022 GMT
*  issuer: C=US; ST=North Carolina; L=Durham; O=Ansible; OU=AWX Development; CN=awx.localhost
*  SSL certificate verify result: self signed certificate (18), continuing anyway.
> POST /api/v2/job_templates/9/callback/ HTTP/1.1
> Host: 10.9.99.10:8043
> User-Agent: curl/7.58.0
> Accept: */*
> Content-Type:application/json
> Content-Length: 59
>
* upload completely sent off: 59 out of 59 bytes
< HTTP/1.1 201 Created
HTTP/1.1 201 Created
< Server: nginx
Server: nginx
< Date: Sun, 05 Sep 2021 03:23:16 GMT
Date: Sun, 05 Sep 2021 03:23:16 GMT
< Content-Length: 0
Content-Length: 0
< Connection: keep-alive
Connection: keep-alive
< Location: /api/v2/jobs/15/
Location: /api/v2/jobs/15/
< Vary: Accept, Accept-Language, Origin, Cookie
Vary: Accept, Accept-Language, Origin, Cookie
< Allow: GET, POST, HEAD, OPTIONS
Allow: GET, POST, HEAD, OPTIONS
< X-API-Product-Version: 19.3.0
X-API-Product-Version: 19.3.0
< X-API-Product-Name: AWX
X-API-Product-Name: AWX
< X-API-Node: awx_1
X-API-Node: awx_1
< X-API-Time: 0.261s
X-API-Time: 0.261s
< X-API-Query-Count: 87
X-API-Query-Count: 87
< X-API-Query-Time: 0.094s
X-API-Query-Time: 0.094s
< Content-Language: en
Content-Language: en
< X-API-Total-Time: 0.330s
X-API-Total-Time: 0.330s
< X-API-Request-Id: 1dd2fcdb1c2346b488d1b3ab85ae860e
X-API-Request-Id: 1dd2fcdb1c2346b488d1b3ab85ae860e
< Access-Control-Expose-Headers: X-API-Request-Id
Access-Control-Expose-Headers: X-API-Request-Id
< Strict-Transport-Security: max-age=15768000
Strict-Transport-Security: max-age=15768000

<
* Connection #0 to host 10.9.99.10 left intact
```

Back in Ansible Tower, click on __Jobs__ in the menue on the left
You should see a successful Job
![Ansible Tower](images/ansible-tower-jobs.png?raw=true "Ansible Tower")

And you can click on the job for more details
![Ansible Tower](images/ansible-tower-job-details.png?raw=true "Ansible Tower")

For Windows, let's create a Job Template
![Ansible Tower](images/ansible-tower-add-template-windows.png?raw=true "Ansible Tower")

Also be sure to tick: 
- Privilege Escalation
- Provisioning Callbacks

And for Windows we need to tell Ansible to use SSH and we need to specify the Shell
Pass the following in the extra variables section otherwise you will receive an error about Temp directory, see below
![Ansible Tower](images/ansible-tower-add-template-more-windows.png?raw=true "Ansible Tower")

```
ansible_shell_type: cmd
ansible_connection: ssh
```

![Ansible Tower](images/ansible-tower-job-details-windows-temp-dir-error.png?raw=true "Ansible Tower")

Let's use our Callback URL and the Host Config Key to trigger a run using Curl
           
__vagrant@ANSIBLE-ROLE-EX C:\Users\vagrant>__ `powershell.exe -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true };Invoke-WebRequest -UseBasicParsing -Uri https://10.9.99.10:8043/api/v2/job_templates/10/callback/ -Method POST -Body @{host_config_key='UL3H6uRtDozHA13trZudrUwUPBw4rSo7rRvi'}"`
```
StatusCode        : 201
StatusDescription : Created
Content           : {}
RawContent        : HTTP/1.1 201 Created
                    Connection: keep-alive
                    Vary: Accept, Accept-Language, Origin, Cookie
                    Allow: GET, POST, HEAD, OPTIONS
                    X-API-Product-Version: 19.3.0
                    X-API-Product-Name: AWX
                    X-API-Node: awx_1...
Headers           : {[Connection, keep-alive], [Vary, Accept, Accept-Language, Origin, Cookie], [Allow, GET, POST, HEAD, OPTIONS], [X-API-Product-Version,
                    19.3.0]...}
RawContentLength  : 0
```

Back in Ansible Tower, click on __Jobs__ in the menue on the left
You should see a successful Job
![Ansible Tower](images/ansible-tower-job-details-windows.png?raw=true "Ansible Tower")

## AWX CLI and TOWER CLI 
One thing I've always struggled with was feedback from Ansible Tower to a pipeline, for example how do we know if a run succeeded or failed.
Then I discovered AWX CLI and TOWER CLI and it can be installed with pip

Awx: `pip3 install awxkit`
Ansible Tower: `pip3 install ansible-tower-cli`

Using the Job template and inventory we created further up in the page we can now issue a run using AWX CLI

__vagrant@hashiqube0:~$__ `awx --conf.host https://10.9.99.10:8043 -f human job_templates launch 9 --monitor --filter status --conf.insecure --conf.username admin --conf.password password`
```
------Starting Standard Out Stream------
[DEPRECATION WARNING]: COMMAND_WARNINGS option, the command warnings feature is
 being removed. This feature will be removed from ansible-core in version 2.14.
 Deprecation warnings can be disabled by setting deprecation_warnings=False in
ansible.cfg.
SSH password:

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host 10.9.99.10 should use
/usr/bin/python3, but is using /usr/bin/python for backward compatibility with
prior Ansible releases. A future Ansible release will default to using the
discovered platform python for this host. See https://docs.ansible.com/ansible-
core/2.11/reference_appendices/interpreter_discovery.html for more information.
 This feature will be removed in version 2.12. Deprecation warnings can be
disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : Cloud] *************************************************
skipping: [10.9.99.10]

TASK [/runner/project : OS] ****************************************************
skipping: [10.9.99.10]

TASK [/runner/project : Write Ansible hostvars to file] ************************
skipping: [10.9.99.10]

TASK [/runner/project : Enable EPEL Repository] ********************************
skipping: [10.9.99.10]

TASK [/runner/project : Ensure package manager repositories are configured | Get repo list] ***
skipping: [10.9.99.10]

TASK [/runner/project : Ensure package manager repositories are configured | Display repo list] ***
skipping: [10.9.99.10]

TASK [/runner/project : Get repo files list] ***********************************
skipping: [10.9.99.10]

TASK [/runner/project : Ensure package manager repositories are configured | Display repo list] ***
skipping: [10.9.99.10]

TASK [/runner/project : Install Package dependencies] **************************
skipping: [10.9.99.10] => (item=aide)
skipping: [10.9.99.10] => (item=ipset)
skipping: [10.9.99.10] => (item=firewalld)

TASK [/runner/project : FIX RHEL8-CIS SCORED | 1.4.1 | PATCH | Ensure X is installed] ***
skipping: [10.9.99.10] => (item=http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/aide-0.16-14.el8.x86_64.rpm)

TASK [/runner/project : FIX RHEL7-CIS AUTOMATED | 1.4.1 | PATCH | Ensure X is installed] ***
skipping: [10.9.99.10] => (item=http://mirror.centos.org/centos/7/os/x86_64/Packages/aide-0.15.1-13.el7.x86_64.rpm)

TASK [/runner/project : OS] ****************************************************
ok: [10.9.99.10] => {
    "msg": "Ubuntu 18.04 bionic on innotek GmbH"
}

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
ok: [10.9.99.10]

TASK [/runner/project : Write Ansible hostvars to file] ************************
changed: [10.9.99.10]

TASK [/runner/project : OS] ****************************************************
skipping: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : set_fact] **********************************************
skipping: [10.9.99.10]

TASK [/runner/project : Write Ansible hostvars to file] ************************
skipping: [10.9.99.10]

PLAY RECAP *********************************************************************
10.9.99.10                 : ok=4    changed=1    unreachable=0    failed=0    skipped=24   rescued=0    ignored=0

------End of Standard Out Stream--------

status
==========
successful
```

## Terraform calling Ansible Tower
So using the configuration above, let's use terraform to kick of an ansible run and display the output

We are going to use local-exec and remote-exec

```
locals {
  timestamp = timestamp()
}

resource "null_resource" "awx_cli" {
  triggers = {
    timestamp = local.timestamp
  }

  provisioner "remote-exec" {
    inline = [
      "/home/vagrant/.local/bin/awx --conf.host https://10.9.99.10:8043 -f human job_templates launch 9 --monitor --filter status --conf.insecure --conf.username admin --conf.password password",
    ]

    connection {
      type        = "ssh"
      user        = "vagrant"
      password    = "vagrant"
      host        = "10.9.99.10"
    }
  }

  provisioner "local-exec" {
    command = "/usr/local/bin/awx --conf.host https://10.9.99.10:8043 -f human job_templates launch 9 --monitor --filter status --conf.insecure --conf.username admin --conf.password password"
  }
}
```

__~/workspace/hashiqube/ansible-tower(master*) »__ `terraform init`

```
Initializing the backend...

Initializing provider plugins...
- Using previously-installed hashicorp/null v3.1.0

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, we recommend adding version constraints in a required_providers block
in your configuration, with the constraint strings suggested below.

* hashicorp/null: version = "~> 3.1.0"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

__~/workspace/hashiqube/ansible-tower(master*) »__ `terraform apply --auto-approve`

```
null_resource.awx_cli: Refreshing state... [id=2181705754889762329]
null_resource.awx_cli: Destroying... [id=2181705754889762329]
null_resource.awx_cli: Destruction complete after 0s
null_resource.awx_cli: Creating...
null_resource.awx_cli: Provisioning with 'remote-exec'...
null_resource.awx_cli (remote-exec): Connecting to remote host via SSH...
null_resource.awx_cli (remote-exec):   Host: 10.9.99.10
null_resource.awx_cli (remote-exec):   User: vagrant
null_resource.awx_cli (remote-exec):   Password: true
null_resource.awx_cli (remote-exec):   Private key: false
null_resource.awx_cli (remote-exec):   Certificate: false
null_resource.awx_cli (remote-exec):   SSH Agent: true
null_resource.awx_cli (remote-exec):   Checking Host Key: false
null_resource.awx_cli (remote-exec): Connected!
null_resource.awx_cli (remote-exec): ------Starting Standard Out Stream------
null_resource.awx_cli (remote-exec): ansible-playbook [core 2.11.5.post0]
null_resource.awx_cli (remote-exec):   config file = /runner/project/ansible.cfg
null_resource.awx_cli (remote-exec):   configured module search path = ['/home/runner/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules', '/runner/project/library']
null_resource.awx_cli (remote-exec):   ansible python module location = /usr/local/lib/python3.8/site-packages/ansible
null_resource.awx_cli (remote-exec):   ansible collection location = /runner/requirements_collections:/home/runner/.ansible/collections:/usr/share/ansible/collections
null_resource.awx_cli (remote-exec):   executable location = /usr/local/bin/ansible-playbook
null_resource.awx_cli (remote-exec):   python version = 3.8.6 (default, Jan 29 2021, 17:38:16) [GCC 8.4.1 20200928 (Red Hat 8.4.1-1)]
null_resource.awx_cli (remote-exec):   jinja version = 2.10.3
null_resource.awx_cli (remote-exec):   libyaml = True
null_resource.awx_cli (remote-exec): Using /runner/project/ansible.cfg as config file
null_resource.awx_cli (remote-exec): [DEPRECATION WARNING]: COMMAND_WARNINGS option, the command warnings feature is
null_resource.awx_cli (remote-exec):  being removed. This feature will be removed from ansible-core in version 2.14.
null_resource.awx_cli (remote-exec):  Deprecation warnings can be disabled by setting deprecation_warnings=False in
null_resource.awx_cli (remote-exec): ansible.cfg.
null_resource.awx_cli (remote-exec): SSH password:
null_resource.awx_cli: Still creating... [10s elapsed]
null_resource.awx_cli (remote-exec): statically imported: /runner/project/tasks/el.yml
null_resource.awx_cli (remote-exec): statically imported: /runner/project/tasks/deb.yml
null_resource.awx_cli (remote-exec): statically imported: /runner/project/tasks/windows.yml
null_resource.awx_cli (remote-exec): Skipping callback 'awx_display', as we already have a stdout callback.
null_resource.awx_cli (remote-exec): Skipping callback 'default', as we already have a stdout callback.
null_resource.awx_cli (remote-exec): Skipping callback 'minimal', as we already have a stdout callback.
null_resource.awx_cli (remote-exec): Skipping callback 'oneline', as we already have a stdout callback.

null_resource.awx_cli (remote-exec): PLAYBOOK: site.yml *************************************************************
null_resource.awx_cli (remote-exec): 1 plays in site.yml

null_resource.awx_cli (remote-exec): PLAY [all] *********************************************************************

null_resource.awx_cli (remote-exec): TASK [Gathering Facts] *********************************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/site.yml:2
null_resource.awx_cli (remote-exec): [DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host 10.9.99.10 should use
null_resource.awx_cli (remote-exec): /usr/bin/python3, but is using /usr/bin/python for backward compatibility with
null_resource.awx_cli (remote-exec): prior Ansible releases. A future Ansible release will default to using the
null_resource.awx_cli (remote-exec): discovered platform python for this host. See https://docs.ansible.com/ansible-
null_resource.awx_cli (remote-exec): core/2.11/reference_appendices/interpreter_discovery.html for more information.
null_resource.awx_cli (remote-exec):  This feature will be removed in version 2.12. Deprecation warnings can be
null_resource.awx_cli (remote-exec): disabled by setting deprecation_warnings=False in ansible.cfg.
null_resource.awx_cli (remote-exec): ok: [10.9.99.10]
null_resource.awx_cli (remote-exec): META: ran handlers

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:9
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:14
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:19
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:24
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : Cloud] *************************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:29
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {}

null_resource.awx_cli (remote-exec): TASK [/runner/project : OS] ****************************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:33
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {}

null_resource.awx_cli (remote-exec): TASK [/runner/project : Write Ansible hostvars to file] ************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:37
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : Enable EPEL Repository] ********************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:46
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : Ensure package manager repositories are configured | Get repo list] ***
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:56
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : Ensure package manager repositories are configured | Display repo list] ***
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:65
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {}

null_resource.awx_cli (remote-exec): TASK [/runner/project : Get repo files list] ***********************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:71
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : Ensure package manager repositories are configured | Display repo list] ***
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:75
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {}

null_resource.awx_cli (remote-exec): TASK [/runner/project : Install Package dependencies] **************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:81
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => (item=aide)  => {"ansible_loop_var": "item", "changed": false, "item": "aide", "skip_reason": "Conditional result was False"}
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => (item=ipset)  => {"ansible_loop_var": "item", "changed": false, "item": "ipset", "skip_reason": "Conditional result was False"}
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => (item=firewalld)  => {"ansible_loop_var": "item", "changed": false, "item": "firewalld", "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : FIX RHEL8-CIS SCORED | 1.4.1 | PATCH | Ensure X is installed] ***
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:102
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => (item=http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/aide-0.16-14.el8.x86_64.rpm)  => {"ansible_loop_var": "item", "changed": false, "item": "http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/aide-0.16-14.el8.x86_64.rpm", "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : FIX RHEL7-CIS AUTOMATED | 1.4.1 | PATCH | Ensure X is installed] ***
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/el.yml:115
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => (item=http://mirror.centos.org/centos/7/os/x86_64/Packages/aide-0.15.1-13.el7.x86_64.rpm)  => {"ansible_loop_var": "item", "changed": false, "item": "http://mirror.centos.org/centos/7/os/x86_64/Packages/aide-0.15.1-13.el7.x86_64.rpm", "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : OS] ****************************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/deb.yml:8
null_resource.awx_cli (remote-exec): ok: [10.9.99.10] => {
null_resource.awx_cli (remote-exec):     "msg": "Ubuntu 18.04 bionic on innotek GmbH"
null_resource.awx_cli (remote-exec): }

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/deb.yml:12
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/deb.yml:17
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/deb.yml:22
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/deb.yml:27
null_resource.awx_cli (remote-exec): ok: [10.9.99.10] => {"ansible_facts": {"cloud": "vagrant"}, "changed": false}

null_resource.awx_cli (remote-exec): TASK [/runner/project : Write Ansible hostvars to file] ************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/deb.yml:32
null_resource.awx_cli (remote-exec): changed: [10.9.99.10] => {"changed": true, "checksum": "9a8877d65d2ea053b348fd733e0b35c3fe67587e", "dest": "/soe-20210703201014.json", "gid": 0, "group": "root", "md5sum": "da8cfcb796842fa90cfa200cab4e05fa", "mode": "0644", "owner": "root", "size": 77371, "src": "/tmp/ansible-tmp-1632275535.6399148-87-109361542358393/source", "state": "file", "uid": 0}

null_resource.awx_cli (remote-exec): TASK [/runner/project : OS] ****************************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/windows.yml:8
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {}

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/windows.yml:12
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/windows.yml:17
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/windows.yml:22
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/windows.yml:27
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (remote-exec): TASK [/runner/project : Write Ansible hostvars to file] ************************
null_resource.awx_cli (remote-exec): task path: /runner/project/tasks/windows.yml:32
null_resource.awx_cli (remote-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}
null_resource.awx_cli (remote-exec): META: role_complete for 10.9.99.10
null_resource.awx_cli (remote-exec): META: ran handlers
null_resource.awx_cli (remote-exec): META: ran handlers

null_resource.awx_cli (remote-exec): PLAY RECAP *********************************************************************
null_resource.awx_cli (remote-exec): 10.9.99.10                 : ok=4    changed=1    unreachable=0    failed=0    skipped=24   rescued=0    ignored=0

null_resource.awx_cli (remote-exec): ------End of Standard Out Stream--------
null_resource.awx_cli (remote-exec):
null_resource.awx_cli (remote-exec): status
null_resource.awx_cli (remote-exec): ==========
null_resource.awx_cli (remote-exec): successful
null_resource.awx_cli: Provisioning with 'local-exec'...
null_resource.awx_cli (local-exec): Executing: ["/bin/sh" "-c" "/usr/local/bin/awx --conf.host https://10.9.99.10:8043 -f human job_templates launch 9 --monitor --filter status --conf.insecure --conf.username admin --conf.password password"]
null_resource.awx_cli: Still creating... [20s elapsed]
null_resource.awx_cli: Still creating... [30s elapsed]
null_resource.awx_cli (local-exec): ------Starting Standard Out Stream------
null_resource.awx_cli (local-exec): ansible-playbook [core 2.11.5.post0]
null_resource.awx_cli (local-exec):   config file = /runner/project/ansible.cfg
null_resource.awx_cli (local-exec):   configured module search path = ['/home/runner/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules', '/runner/project/library']
null_resource.awx_cli (local-exec):   ansible python module location = /usr/local/lib/python3.8/site-packages/ansible
null_resource.awx_cli (local-exec):   ansible collection location = /runner/requirements_collections:/home/runner/.ansible/collections:/usr/share/ansible/collections
null_resource.awx_cli (local-exec):   executable location = /usr/local/bin/ansible-playbook
null_resource.awx_cli (local-exec):   python version = 3.8.6 (default, Jan 29 2021, 17:38:16) [GCC 8.4.1 20200928 (Red Hat 8.4.1-1)]
null_resource.awx_cli (local-exec):   jinja version = 2.10.3
null_resource.awx_cli (local-exec):   libyaml = True
null_resource.awx_cli (local-exec): Using /runner/project/ansible.cfg as config file
null_resource.awx_cli (local-exec): [DEPRECATION WARNING]: COMMAND_WARNINGS option, the command warnings feature is
null_resource.awx_cli (local-exec):  being removed. This feature will be removed from ansible-core in version 2.14.
null_resource.awx_cli (local-exec):  Deprecation warnings can be disabled by setting deprecation_warnings=False in
null_resource.awx_cli (local-exec): ansible.cfg.
null_resource.awx_cli (local-exec): SSH password:
null_resource.awx_cli (local-exec): statically imported: /runner/project/tasks/el.yml
null_resource.awx_cli (local-exec): statically imported: /runner/project/tasks/deb.yml
null_resource.awx_cli (local-exec): statically imported: /runner/project/tasks/windows.yml
null_resource.awx_cli (local-exec): Skipping callback 'awx_display', as we already have a stdout callback.
null_resource.awx_cli (local-exec): Skipping callback 'default', as we already have a stdout callback.
null_resource.awx_cli (local-exec): Skipping callback 'minimal', as we already have a stdout callback.
null_resource.awx_cli (local-exec): Skipping callback 'oneline', as we already have a stdout callback.

null_resource.awx_cli (local-exec): PLAYBOOK: site.yml *************************************************************
null_resource.awx_cli (local-exec): 1 plays in site.yml

null_resource.awx_cli (local-exec): PLAY [all] *********************************************************************

null_resource.awx_cli (local-exec): TASK [Gathering Facts] *********************************************************
null_resource.awx_cli (local-exec): task path: /runner/project/site.yml:2
null_resource.awx_cli (local-exec): [DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host 10.9.99.10 should use
null_resource.awx_cli (local-exec): /usr/bin/python3, but is using /usr/bin/python for backward compatibility with
null_resource.awx_cli (local-exec): prior Ansible releases. A future Ansible release will default to using the
null_resource.awx_cli (local-exec): discovered platform python for this host. See https://docs.ansible.com/ansible-
null_resource.awx_cli (local-exec): core/2.11/reference_appendices/interpreter_discovery.html for more information.
null_resource.awx_cli (local-exec):  This feature will be removed in version 2.12. Deprecation warnings can be
null_resource.awx_cli (local-exec): disabled by setting deprecation_warnings=False in ansible.cfg.
null_resource.awx_cli (local-exec): ok: [10.9.99.10]
null_resource.awx_cli (local-exec): META: ran handlers

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:9
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:14
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:19
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:24
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : Cloud] *************************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:29
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {}

null_resource.awx_cli (local-exec): TASK [/runner/project : OS] ****************************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:33
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {}

null_resource.awx_cli (local-exec): TASK [/runner/project : Write Ansible hostvars to file] ************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:37
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : Enable EPEL Repository] ********************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:46
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : Ensure package manager repositories are configured | Get repo list] ***
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:56
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : Ensure package manager repositories are configured | Display repo list] ***
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:65
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {}

null_resource.awx_cli (local-exec): TASK [/runner/project : Get repo files list] ***********************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:71
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : Ensure package manager repositories are configured | Display repo list] ***
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:75
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {}

null_resource.awx_cli (local-exec): TASK [/runner/project : Install Package dependencies] **************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:81
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => (item=aide)  => {"ansible_loop_var": "item", "changed": false, "item": "aide", "skip_reason": "Conditional result was False"}
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => (item=ipset)  => {"ansible_loop_var": "item", "changed": false, "item": "ipset", "skip_reason": "Conditional result was False"}
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => (item=firewalld)  => {"ansible_loop_var": "item", "changed": false, "item": "firewalld", "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : FIX RHEL8-CIS SCORED | 1.4.1 | PATCH | Ensure X is installed] ***
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:102
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => (item=http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/aide-0.16-14.el8.x86_64.rpm)  => {"ansible_loop_var": "item", "changed": false, "item": "http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/aide-0.16-14.el8.x86_64.rpm", "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : FIX RHEL7-CIS AUTOMATED | 1.4.1 | PATCH | Ensure X is installed] ***
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/el.yml:115
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => (item=http://mirror.centos.org/centos/7/os/x86_64/Packages/aide-0.15.1-13.el7.x86_64.rpm)  => {"ansible_loop_var": "item", "changed": false, "item": "http://mirror.centos.org/centos/7/os/x86_64/Packages/aide-0.15.1-13.el7.x86_64.rpm", "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : OS] ****************************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/deb.yml:8
null_resource.awx_cli (local-exec): ok: [10.9.99.10] => {
null_resource.awx_cli (local-exec):     "msg": "Ubuntu 18.04 bionic on innotek GmbH"
null_resource.awx_cli (local-exec): }

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/deb.yml:12
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/deb.yml:17
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/deb.yml:22
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/deb.yml:27
null_resource.awx_cli (local-exec): ok: [10.9.99.10] => {"ansible_facts": {"cloud": "vagrant"}, "changed": false}

null_resource.awx_cli (local-exec): TASK [/runner/project : Write Ansible hostvars to file] ************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/deb.yml:32
null_resource.awx_cli (local-exec): changed: [10.9.99.10] => {"changed": true, "checksum": "eea47aeb336e4b507f8dc851b5999f04fdc3d5aa", "dest": "/soe-20210703201014.json", "gid": 0, "group": "root", "md5sum": "c09a9e6b638526aea9d83a7d30c03d58", "mode": "0644", "owner": "root", "size": 77371, "src": "/tmp/ansible-tmp-1632275552.8567505-87-55845101901960/source", "state": "file", "uid": 0}

null_resource.awx_cli (local-exec): TASK [/runner/project : OS] ****************************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/windows.yml:8
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {}

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/windows.yml:12
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/windows.yml:17
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/windows.yml:22
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : set_fact] **********************************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/windows.yml:27
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}

null_resource.awx_cli (local-exec): TASK [/runner/project : Write Ansible hostvars to file] ************************
null_resource.awx_cli (local-exec): task path: /runner/project/tasks/windows.yml:32
null_resource.awx_cli (local-exec): skipping: [10.9.99.10] => {"changed": false, "skip_reason": "Conditional result was False"}
null_resource.awx_cli (local-exec): META: role_complete for 10.9.99.10
null_resource.awx_cli (local-exec): META: ran handlers
null_resource.awx_cli (local-exec): META: ran handlers

null_resource.awx_cli (local-exec): PLAY RECAP *********************************************************************
null_resource.awx_cli (local-exec): 10.9.99.10                 : ok=4    changed=1    unreachable=0    failed=0    skipped=24   rescued=0    ignored=0

null_resource.awx_cli (local-exec): ------End of Standard Out Stream--------
null_resource.awx_cli (local-exec):
null_resource.awx_cli (local-exec): status
null_resource.awx_cli (local-exec): ==========
null_resource.awx_cli (local-exec): successful
null_resource.awx_cli: Creation complete after 36s [id=936123805330159798]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
```
