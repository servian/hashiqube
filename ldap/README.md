# LDAP
https://www.vaultproject.io/docs/auth/ldap.html

LDAP stands for Lightweight Directory Access Protocol. As the name suggests, it is a lightweight client-server protocol for accessing directory services, specifically X. 500-based directory services. LDAP runs over TCP/IP or other connection oriented transfer services.

## Provision
`vagrant up --provision-with ldap`

```                                                                        
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: A newer version of the box 'ubuntu/xenial64' for provider 'virtualbox' is
==> user.local.dev: available! You currently have version '20190918.0.0'. The latest is version
==> user.local.dev: '20200108.0.0'. Run `vagrant box update` to update.
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: Running provisioner: ldap (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200112-42422-54mu94.sh
    user.local.dev: Error response from daemon: No such container: ldap
    user.local.dev: Error: No such container: ldap
    user.local.dev: WARNING! This will remove:
    user.local.dev:   - all stopped containers
    user.local.dev:   - all networks not used by at least one container
    user.local.dev:   - all images without at least one container associated to them
    user.local.dev:   - all build cache
    user.local.dev:
    user.local.dev: Are you sure you want to continue? [y/N]
    user.local.dev: Total reclaimed space: 0B
    user.local.dev: WARNING! This will remove:
    user.local.dev:   - all stopped containers
    user.local.dev:   - all networks not used by at least one container
    user.local.dev:   - all volumes not used by at least one container
    user.local.dev:   - all dangling images
    user.local.dev:   - all dangling build cache
    user.local.dev:
    user.local.dev: Are you sure you want to continue? [y/N]
    user.local.dev: Total reclaimed space: 0B
    user.local.dev: Unable to find image 'rroemhild/test-openldap:latest' locally
    user.local.dev: latest: Pulling from rroemhild/test-openldap
    user.local.dev: 8f91359f1fff: Pulling fs layer
    user.local.dev: 8458cf10881b: Pulling fs layer
    user.local.dev: 2d09b054bd7f: Pulling fs layer
    user.local.dev: 1d4d29320e86: Pulling fs layer
    user.local.dev: 5bf9bcc17444: Pulling fs layer
    user.local.dev: 1d4d29320e86: Waiting
    user.local.dev: 5bf9bcc17444: Waiting
    user.local.dev: 2d09b054bd7f: Verifying Checksum
    user.local.dev: 2d09b054bd7f: Download complete
    user.local.dev: 1d4d29320e86: Verifying Checksum
    user.local.dev: 1d4d29320e86: Download complete
    user.local.dev: 5bf9bcc17444:
    user.local.dev: Download complete
    user.local.dev: 8458cf10881b: Verifying Checksum
    user.local.dev: 8458cf10881b: Download complete
    user.local.dev: 8f91359f1fff: Verifying Checksum
    user.local.dev: 8f91359f1fff: Download complete
    user.local.dev: 8f91359f1fff: Pull complete
    user.local.dev: 8458cf10881b: Pull complete
    user.local.dev: 2d09b054bd7f: Pull complete
    user.local.dev: 1d4d29320e86: Pull complete
    user.local.dev: 5bf9bcc17444: Pull complete
    user.local.dev: Digest: sha256:a0dc748e4132fbdaa88a3adb189b6da65bc3eb1a4e2d7611a51ecf018431847b
    user.local.dev: Status: Downloaded newer image for rroemhild/test-openldap:latest
    user.local.dev: 910085a603a0a4007d3a916f9659d4cac23356bd1fd05eed5193cf805071b5c5
    user.local.dev: ++++ To use this in Vault please do
    user.local.dev: ++++ vault write auth/ldap/config url="ldap://localhost:389" userdn="ou=people,dc=planetexpress,dc=com" groupdn="ou=people,dc=planetexpress,dc=com" groupattr="cn" insecure_tls=true userattr=uid starttls=false binddn="cn=admin,dc=planetexpress,dc=com" bindpass='GoodNewsEveryone'
    user.local.dev: ++++ vault login -method=ldap username=hermes (password: hermes)
```

## Enable LDAP Auth in Vault

`vault auth enable ldap`
```
Success! Enabled ldap auth method at: ldap/
```

`vault write auth/ldap/config url="ldap://localhost:389" userdn="ou=people,dc=planetexpress,dc=com" groupdn="ou=people,dc=planetexpress,dc=com" groupattr="cn" insecure_tls=true userattr=uid starttls=false binddn="cn=admin,dc=planetexpress,dc=com" bindpass='GoodNewsEveryone'`
```
Success! Data written to: auth/ldap/config
```

`vault login -method=ldap username=hermes`
```
Password (will be hidden):
WARNING! The VAULT_TOKEN environment variable is set! This takes precedence
over the value set by this command. To use the value set by this command,
unset the VAULT_TOKEN environment variable or set it to the token displayed
below.

Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.dbcrQVvhuT1RNQiK3FMFiNZe
token_accessor         wNdDBVDTEj3AfAfxypJELiGD
token_duration         10h
token_renewable        true
token_policies         ["default"]
identity_policies      []
policies               ["default"]
token_meta_username    hermes
```
