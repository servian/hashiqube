# packer-rhel

Build RHEL 7:

```console
# packer build rhel7.json
```

Build RHEL 8:

```console
# packer build rhel8.json
```

Test after build:

```console
# export RHEL_VERSION=8
# vagrant up
``´