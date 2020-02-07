# Jenkins
This will help you start the Jenkins container, login with the initial admin token and create a user and password for subsequent logins.

We will also configure Jenkins Hashicorp Vault Plugin https://github.com/jenkinsci/hashicorp-vault-plugin
After that, we will configure Vault's secret engines, KV store version 1 and 2 and set some keys.

For this demo we will use the Vault root access token for Jenkins access. Other authentication methods like LDAP can be enabled later.

Let's start Jenkins

`vagrant up --provision-with jenkins`
```
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 hashicorp.local.dev
==> user.local.dev: Running provisioner: jenkins (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20191111-94138-95y39j.sh
    user.local.dev: jenkins
    user.local.dev: jenkins
    user.local.dev: ca4af6b743c506d0f3954362c00c51f7399c5c22beb90f42e6876af2128f910d
    user.local.dev: To use Jenkins please open in your browser
    user.local.dev: http://localhost:8088
    user.local.dev: Login with 4ed0dc30230c4310a58a22207414c3aa
```
Use the token in the output "Login with `4ed0dc30230c4310a58a22207414c3aa`" to login to Jenkins.
![Jenkins](images/jenkins_initial_admin_token_login.png?raw=true "Jenkins")

Install the suggested plugins for Jenkins.
![Jenkins](images/jenkins_install_suggested_plugins.png?raw=true "Jenkins")

Let the plugins download and install, we will install a few others once we are logged in.
Install the suggested plugins for Jenkins.
![Jenkins](images/jenkins_install_suggested_plugins_busy_installing.png?raw=true "Jenkins")

Create the first admin user for Jenkins.
![Jenkins](images/jenkins_create_first_admin_user.png?raw=true "Jenkins")

Click `Save and Finish` for the initial instance configuration setting the Jenkins URL.
![Jenkins](images/jenkins_install_instance_configuration.png?raw=true "Jenkins")

Let's start using Jenkins!
![Jenkins](images/jenkins_start_using_jenkins.png?raw=true "Jenkins")

Now let's install a few more plugins, click on `Manage Jenkins -> Manage Plugins`
![Jenkins](images/jenkins_manage_jenkins_manage_plugins.png?raw=true "Jenkins")

Click on `Available` and search for `HashiCorp Vault` and select it, next search for `Pipeline: Multibranch with defaults` and select that too, now click `Download and Install after Restart` once done and installed, select `Restart Jenkins once Installation is Complete`
![Jenkins](images/jenkins_restart_jenkins_when_plugin_installation_complete.png?raw=true "Jenkins")

Now click top Right `Enable Automatic Refresh` this will take you back to the Jenkins login page, now login with the credentials you created at `Create the first admin user for Jenkins.`

Before we continue let's make sure Vault is running and it is unsealed. In a terminal please run

### Vault
`vagrant up --provision-with vault`
```
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 consul-user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 vault-user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 nomad-user.local.dev
==> user.local.dev: Running provisioner: vault (shell)...
   user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20191024-26402-1ms4n4s.sh
   user.local.dev: Vault already installed and running
   user.local.dev: Vault http://localhost:8200/ui and enter the following codes displayed below
   user.local.dev: Unseal Key 1: aRBITqqWe57Tl38J9avHZVoow2oC6C2qjEgWFqQAV4Z1
   user.local.dev: Unseal Key 2: +Z0RHNn1lBkKas5WIiuXYha5LTA/7i+ncLBdJafBpNs8
   user.local.dev: Unseal Key 3: 0Wg9qT6rNeB1fm5CDUdEuM8nWtI6Jt5PTAT6z0HkZRBY
   user.local.dev: Unseal Key 4: ysw0/LJPGy4jfhoPG6Lvm+ARBzkT8Q70cXgvPRZRd5Pi
   user.local.dev: Unseal Key 5: g6el6P2RAtwymn8tHE38ltdyiOeEf1Wfn8+8kShxIdZP
   user.local.dev:
   user.local.dev: Initial Root Token: s.XmyUDCIJkHMA4QgeDO6oykz6
   user.local.dev:
   user.local.dev: Vault initialized with 5 key shares and a key threshold of 3. Please securely
   user.local.dev: distribute the key shares printed above. When the Vault is re-sealed,
   user.local.dev: restarted, or stopped, you must supply at least 3 of these keys to unseal it
   user.local.dev: before it can start servicing requests.
   user.local.dev:
   user.local.dev: Vault does not store the generated master key. Without at least 3 key to
   user.local.dev: reconstruct the master key, Vault will remain permanently sealed!
   user.local.dev:
   user.local.dev: It is possible to generate new unseal keys, provided you have a quorum of
   user.local.dev: existing unseal keys shares. See "vault operator rekey" for more information.
```
Now open up `http://localhost:8200`
Vault will start up sealed. We need unseal Vault to use it.

Enter 3 of the 5 Unseal keys printed above, lastly, enter the `Initial Root Token`
You need to be logged into Vault and should see the screen below.
![Vault](images/vault_unsealed_and_logged_in.png?raw=true "Vault")

Now let's enable KV secret engines V1 and V2 and add some data for Jenkins to use.
Click on `Enable new engine +` (Top right)
![Vault](images/vault_enable_secrets_engine_kv.png?raw=true "Vault")

Vault has made a version 2 of the KV secrets engine, to help us distinguish between versions, we will make the path v1 and v2 respectively.
![Vault](images/vault_enable_secrets_engine_kv2.png?raw=true "Vault")

Now that KV v2 has been enabled, let's add some secrets, please click on `Create secret +` (Top right)
Here we now need to reference the Jenkinsfile that I have prepared for you, the following
```
def secrets = [
  [path: 'kv2/secret/another_test', engineVersion: 2, secretValues: [
  [vaultKey: 'another_test']]]
  [path: 'kv1/secret/testing', engineVersion: 1, secretValues: [
  [envVar: 'testing', vaultKey: 'value_one'],
  [envVar: 'testing_again', vaultKey: 'value_two']]]
]
```
Add as the path `secret/another_test` and as the key `another_test` with some data of your choice.
![Vault](images/vault_enable_secrets_engine_kv2_secret_another_test.png?raw=true "Vault")

Also enable KV v1
![Vault](images/vault_enable_secrets_engine_kv1.png?raw=true "Vault")

And set the keys below
```
Path: secret/testing
Key: value_one Value: Any data of your choice for Vault KV v1 value_one
Key: value_two Value: Any data of your choice for Vault KV v1 value_two
```
![Vault](images/vault_enable_secrets_engine_kv1_secret_value_one_and_value_two.png?raw=true "Vault")

Now let's connect Jenkins with Vault.

In Jenkins, click on `Manage Jenkins -> Configure System` and scroll down to Vault.
![Jenkins](images/jenkins_manage_jenkins_configure_system_vault.png?raw=true "Jenkins")

For Vault address use `http://10.9.99.10:8200` The IP Address is set in the Vagrantfile in the `machines {}`
Click `Skip SSL Validation` for this demo.

Now we need to add the Vault root token for Jenkins to communicate with Vault
![Jenkins](images/jenkins_manage_jenkins_configure_system_vault_initial_root_token.png?raw=true "Jenkins")

Now we can create our first Jenkins job!

In Jenkins click on `New Item -> Pipeline` and give it a name, I used `vault-jenkins` and click apply.
Scroll down until you get to the pipeline definition and enter the following data (it is the Jenkinsfile in the jenkins directory)

```
// https://github.com/jenkinsci/hashicorp-vault-plugin

node {

  stage('Checkout Source Code') {
    sh 'echo "Check out application source code"'
  }

  stage('Get ENV vars from Vault') {
    // define the secrets and the env variables
    // engine version can be defined on secret, job, folder or global.
    // the default is engine version 2 unless otherwise specified globally.
    def secrets = [
      [path: 'kv2/secret/another_test', engineVersion: 2, secretValues: [
      [vaultKey: 'another_test']]],
      [path: 'kv1/secret/testing', engineVersion: 1, secretValues: [
      [envVar: 'testing', vaultKey: 'value_one'],
      [envVar: 'testing_again', vaultKey: 'value_two']]]
    ]

    // optional configuration, if you do not provide this the next higher configuration
    // (e.g. folder or global) will be used
    def configuration = [vaultUrl: 'http://10.9.99.10:8200',
      vaultCredentialId: 'vault-initial-root-token',
      engineVersion: 1]

    // inside this block your credentials will be available as env variables
    withVault([configuration: configuration, vaultSecrets: secrets]) {
      sh 'echo $testing'
      sh 'echo $testing_again'
      sh 'echo $another_test'
    }
  }

  stage('Echo some ENV vars') {
    withCredentials([[$class: 'VaultTokenCredentialBinding', credentialsId: 'vault-initial-root-token', vaultAddr: 'http://10.9.99.10:8200']]) {
      // values will be masked
      sh 'echo TOKEN=$VAULT_TOKEN'
      sh 'echo ADDR=$VAULT_ADDR'
    }
    echo sh(script: 'env|sort', returnStdout: true)
  }
}
```
![Jenkins](images/jenkins_new_item_pipeline_vault-jenkins_configure.png?raw=true "Jenkins")

Click Save.

Now let's build the job, click on `Build Now` (Right menu) You should see bottom left a successful build.
![Jenkins](images/jenkins_job_vault-jenkins_build.png?raw=true "Jenkins")

You can click on that job and view the console, for more output, you should see your secrets are totally hidden and provided by Vault.
![Jenkins](images/jenkins_job_vault-jenkins_build_console.png?raw=true "Jenkins")
