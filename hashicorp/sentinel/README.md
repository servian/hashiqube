# TFE Policies Example

This repo demonstrates a complete VCS-backed Sentinel workflow for Terraform Enterprise (TFE). It includes the following components:

- Some example Sentinel policies that define rules about Terraform runs.
- Sentinel test configurations for those policies.
- A Terraform configuration to sync those policies with Terraform Enterprise, group them into sets, and enforce them on workspaces.

It is intended to be combined with the following:

- A Terraform Enterprise workspace, which runs Terraform to update your Sentinel policies whenever the repo changes.
- A lightweight CI solution (like GitHub Actions), for continuously testing your Sentinel code.

> **See also:** This repo shows an end-to-end workflow with many parts, and uses a small number of Sentinel policies to keep things simple. If you'd rather see a wider range of how to govern specific kinds of infrastructure with Sentinel policies, see the [example policies in the hashicorp/terraform-guides repo](https://github.com/hashicorp/terraform-guides/tree/master/governance).

## Using with TFE

Fork this repo, then create a Terraform Enterprise workspace linked to your fork. Set values for the following Terraform variables:

- `tfe_hostname` (optional; defaults to `app.terraform.io`) — the hostname of your TFE instance.
- `tfe_organization` — the name of your TFE organization.
- `tfe_token` (SENSITIVE) — the organization token or owners team token for your organization.

Add and remove Sentinel policies as desired, and edit `main.tf` to ensure your policies are enforced on the correct workspaces. Queue an initial run to set up your policies, then continue to iterate on the policy repo and approve Terraform runs as needed.

For more details, see [Managing Sentinel Policies with Version Control](https://www.terraform.io/docs/enterprise/sentinel/integrate-vcs.html).

## Testing Sentinel Policies Locally

Run all tests:

    > sentinel test

Manually apply a policy using a specific test config:

    > sentinel apply -config ./test/aws-restrict-instance-type-prod/dev-not-prod.json aws-restrict-instance-type-prod.sentinel

(This example results in a policy failure, as intended; see the `"test"` property of any test config for the expected behavior.)


## Testing Sentinel Policies with Github Actions

This repo contains [an example](.github/main.workflow) of running `sentinel test` against your sentinel files as PR checks. It uses a third-party action called `thrashr888/sentinel-github-actions/test` to run the tests. After submitting a PR, you'll see any test errors show up as a comment on the PR.
