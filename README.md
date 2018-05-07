# opa-release

[Open Policy Agent](https://www.openpolicyagent.org/) (OPA) is an open source, general purpose policy engine that enables unified, context aware policy enforcement across the entire stack

This release allows for the deployment of OPA using BOSH.

## Deployment

Currently there is no CI build the release. You can build it locally and deploy and test using the commands below

You need to provide the `network` and `az` that is specified in the cloud-config for your BOSH installation 

```
git clone git@github.com:bstick12/opa-release.git
bosh create-release
bosh upload-release
bosh deploy -d opa-example examples/manifest.yml -v network_name=<BOSH NETWORK> -v zone=<BOSH ZONE>
OPA_IP=$(bosh vms -d opa-example | awk '{print $4}')
curl "http://${OPA_URL}:8181/"
```




