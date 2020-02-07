# Docsify
https://docsify.js.org/

## About
Docsify is a magical documentation site generator. Docsify generates your documentation website on the fly. Unlike GitBook, it does not generate static html files. Instead, it smartly loads and parses your Markdown files and displays them as a website. To start using it, all you need to do is create an index.html and deploy it on GitHub Pages.

## Provision
`vagrant up --provision-with docsify`

```
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: Running provisioner: docsify (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20200110-27159-1z0wxkm.sh
    user.local.dev:
    user.local.dev: ## Installing the NodeSource Node.js 10.x repo...
    user.local.dev:
    user.local.dev: ## Populating apt-get cache...
    user.local.dev: + apt-get update
    user.local.dev: Hit:1 https://download.docker.com/linux/ubuntu xenial InRelease
    user.local.dev: Hit:2 https://deb.nodesource.com/node_10.x xenial InRelease
    user.local.dev: Hit:3 http://archive.ubuntu.com/ubuntu xenial InRelease
    user.local.dev: Hit:4 http://security.ubuntu.com/ubuntu xenial-security InRelease
    user.local.dev: Hit:5 http://archive.ubuntu.com/ubuntu xenial-updates InRelease
    user.local.dev: Hit:6 http://archive.ubuntu.com/ubuntu xenial-backports InRelease
    user.local.dev: Reading package lists...
    user.local.dev:
    user.local.dev: ## Confirming "xenial" is supported...
    user.local.dev:
    user.local.dev: + curl -sLf -o /dev/null 'https://deb.nodesource.com/node_10.x/dists/xenial/Release'
    user.local.dev:
    user.local.dev: ## Adding the NodeSource signing key to your keyring...
    user.local.dev:
    user.local.dev: + curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
    user.local.dev: OK
    user.local.dev:
    user.local.dev: ## Creating apt sources list file for the NodeSource Node.js 10.x repo...
    user.local.dev:
    user.local.dev: + echo 'deb https://deb.nodesource.com/node_10.x xenial main' > /etc/apt/sources.list.d/nodesource.list
    user.local.dev: + echo 'deb-src https://deb.nodesource.com/node_10.x xenial main' >> /etc/apt/sources.list.d/nodesource.list
    user.local.dev:
    user.local.dev: ## Running `apt-get update` for you...
    user.local.dev:
    user.local.dev: + apt-get update
    user.local.dev: Hit:1 https://deb.nodesource.com/node_10.x xenial InRelease
    user.local.dev: Hit:2 https://download.docker.com/linux/ubuntu xenial InRelease
    user.local.dev: Hit:3 http://archive.ubuntu.com/ubuntu xenial InRelease
    user.local.dev: Hit:4 http://security.ubuntu.com/ubuntu xenial-security InRelease
    user.local.dev: Hit:5 http://archive.ubuntu.com/ubuntu xenial-updates InRelease
    user.local.dev: Hit:6 http://archive.ubuntu.com/ubuntu xenial-backports InRelease
    user.local.dev: Reading package lists...
    user.local.dev:
    user.local.dev: ## Run `sudo apt-get install -y nodejs` to install Node.js 10.x and npm
    user.local.dev: ## You may also need development tools to build native addons:
    user.local.dev:      sudo apt-get install gcc g++ make
    user.local.dev: ## To install the Yarn package manager, run:
    user.local.dev:      curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    user.local.dev:      echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    user.local.dev:      sudo apt-get update && sudo apt-get install yarn
    user.local.dev: Reading package lists...
    user.local.dev: Building dependency tree...
    user.local.dev: Reading state information...
    user.local.dev: nodejs is already the newest version (10.18.0-1nodesource1).
    user.local.dev: 0 upgraded, 0 newly installed, 0 to remove and 6 not upgraded.
    user.local.dev: /usr/bin/docsify -> /usr/lib/node_modules/docsify-cli/bin/docsify
    user.local.dev: + docsify-cli@4.4.0
    user.local.dev: updated 1 package in 15.329s
    user.local.dev: ++++ Docsify: http://localhost:3333/
```

## Summary
After provision, you can access Docsify and HashiQube documentation at http://localhost:3333/
![Docsify](images/docsify.png?raw=true "Docsify")
