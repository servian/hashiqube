#!/bin/bash
packer build --only=vmware-iso --var iso_url=~/packer_cache/insider/Windows10_InsiderPreview_EnterpriseVL_x64_en-us_19035.iso windows_10_insider.json

# packer build --only=vmware-iso \
#   --var iso_url=~/packer_cache/insider/uupdump_19041.1_PROFESSIONAL_X64_EN-US.iso \
#   --var iso_checksum=bcf500c09e2048c8bd2b710ba2b75bed9fe6ef07ea2a584599af81b4b8baa5ed \
#   --var autounattend=tmp/10_pro/Autounattend.xml \
#   windows_10_insider.json
