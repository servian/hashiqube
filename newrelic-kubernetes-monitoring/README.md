# Newrelic Kubernetes Monitoring

This page shows you how to install Newrelic Monitoring using Helm on Minikube

https://docs.newrelic.com/docs/kubernetes-pixie/kubernetes-integration/installation/kubernetes-integration-install-configure
https://kubernetes.io/docs/tasks/tools/install-minikube/
https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

![Newrelic Kubernetes Monitoring](images/newrelic-kubernetes-monitoring.png?raw=true "Newrelic Kubernetes Monitoring")

## Usage

First we need to bring up Hashiqube and ensure that Minikube is running. Please run the following commands inside the Hashiqube folder

```shell
vagrant up --provision-with basetools
vagrant up --provision-with docker
vagrant up --provision-with minikube
```

You should now be able to open Minikube dashboard: http://localhost:10888

![Minikube Dashboard](images/minikube.png?raw=true "Minikube Dashboard")

For more extensive details on how to run Minikube on Hashiqube please visit: [__Minikube__](minikube/#minikube)

## Newrelic

Now we deploy the Newrelic integration ontop of Kubernetes (Minikube) using Helm

But first, head over to http://www.newrelic.com and open a Free Demo account, we will need this for our demo. 

Once you have your Newrelic account open and logged in, we can proceed. 

![Newrelic Logged in](images/01-newrelic-logged-in.png?raw=true "Newrelic Logged in")

Now you can select your account and Kubernetes namespace for the integration

![Newrelic Account and Namespace](images/02-newrelic-select-account-and-namespace.png?raw=true "Newrelic Account and Namespace")

Now we can select the the Newrelic features for the integration

![Newrelic Integration Features](images/03-newrelic-features.png?raw=true "Newrelic Integration Features")

## Install

Please visit https://one.newrelic.com/launcher/k8s-cluster-explorer-nerdlet.cluster-explorer-launcher and follow the steps

At the end will be a Helm command like this that we run in the container. 

![Newrelic Integration Install with Helm](images/04-newrelic-install-with-helm.png?raw=true "Newrelic Integration Install with Helm")

- vagrant ssh 
- now run this command:
```shell
helm repo add newrelic https://helm-charts.newrelic.com && helm repo update && \
> kubectl create namespace newrelic ; helm upgrade --install newrelic-bundle newrelic/nri-bundle \
>  --set global.licenseKey=YOUR_NEWRELIC_LICENSE_KEY \
>  --set global.cluster=minikube \
>  --namespace=newrelic \
>  --set newrelic-infrastructure.privileged=true \
>  --set global.lowDataMode=true \
>  --set ksm.enabled=true \
>  --set kubeEvents.enabled=true \
>  --set prometheus.enabled=true \
>  --set logging.enabled=true \
>  --set newrelic-pixie.enabled=true \
>  --set newrelic-pixie.apiKey=YOUR_PIXIE_API_KEY \
>  --set pixie-chart.enabled=true \
>  --set pixie-chart.deployKey=YOUR_PIXIE_DEPLOY_KEY \
>  --set pixie-chart.clusterName=minikube
```

## Info

*vagrant@hashiqube0:~$* `kubectl get po,svc -n newrelic`

```shell
NAME                                                          READY   STATUS                       RESTARTS      AGE
pod/newrelic-bundle-kube-state-metrics-654df84864-9hvk8       1/1     Running                      0             19m
pod/newrelic-bundle-newrelic-logging-xfs98                    1/1     Running                      0             19m
pod/newrelic-bundle-newrelic-pixie-jxfcv                      0/1     CreateContainerConfigError   0             19m
pod/newrelic-bundle-nri-kube-events-6c65bbbc8f-mjrvt          2/2     Running                      0             19m
pod/newrelic-bundle-nri-metadata-injection-675dd8f8f7-m5vcg   1/1     Running                      0             19m
pod/newrelic-bundle-nri-prometheus-64b9696b7b-xl9kk           1/1     Running                      0             19m
pod/newrelic-bundle-nrk8s-controlplane-lsx5t                  2/2     Running                      1 (17m ago)   19m
pod/newrelic-bundle-nrk8s-ksm-5d598df8d-v8rdv                 2/2     Running                      0             19m
pod/newrelic-bundle-nrk8s-kubelet-9xb68                       2/2     Running                      0             19m

NAME                                             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/newrelic-bundle-kube-state-metrics       ClusterIP   10.107.30.223   <none>        8080/TCP   19m
service/newrelic-bundle-nri-metadata-injection   ClusterIP   10.96.68.196    <none>        443/TCP    19m
```

Within a few minutes you will be able to see the Kubernetes Integrqation 

![Newrelic Kuberneter Integration Clusters](images/05-newrelic-kuibernetes-clusters.png?raw=true "Newrelic Kuberneter Integration Clusters")

And we will be able to see the Data streaming through

![Newrelic Kuberneter Integration Clusters](images/06-newrelic-summary-01.png?raw=true "Newrelic Kuberneter Integration Clusters")

![Newrelic Kuberneter Integration Clusters](images/06-newrelic-summary-02.png?raw=true "Newrelic Kuberneter Integration Clusters")

## TODO

### Pixie
I was unable to get Pixie running, due to `bash: line 225: /home/vagrant/bin/px: cannot execute binary file: Exec format error`

I am currently on a Mac M1 Chipset and this needs deeper debugging to figure out how to run Pixie on ARM64 Chipsets.

*vagrant@hashiqube0:~$* `bash -c "$(curl -fsSL https://work.withpixie.ai/install.sh)"`

```shell

  ___  _       _
 | _ \(_)__ __(_) ___
 |  _/| |\ \ /| |/ -_)
 |_|  |_|/_\_\|_|\___|

==> Info:
Pixie gives engineers access to no-instrumentation, streaming &
unsampled auto-telemetry to debug performance issues in real-time,
More information at: https://www.pixielabs.ai.

This command will install the Pixie CLI (px) in a location selected
by you, and performs authentication with Pixie's cloud hosted control
plane. After installation of the CLI you can easily manage Pixie
installations on your K8s clusters and execute scripts to collect
telemetry from your clusters using Pixie.

Docs:
  https://work.withpixie.ai/docs


==> Terms and Conditions https://www.pixielabs.ai/terms
I have read and accepted the Terms & Conditions [y/n]: y


==> Installing PX CLI:
Install Path [/home/vagrant/bin]: 

==> Authenticating with Pixie Cloud:
bash: line 225: /home/vagrant/bin/px: cannot execute binary file: Exec format error

FAILED to authenticate with Pixie cloud. 
  You can try this step yourself by running px auth login.
  For help, please contact support@pixielabs.ai or join our community slack/github"


==> Next steps:
- PX CLI has been installed to: /home/vagrant/bin. Make sure this directory is in your PATH.
- Run px deploy to deploy Pixie on K8s.
- Run px help to get started, or visit our UI: https://work.withpixie.ai
- Further documentation:
    https://work.withpixie.ai/docs
```

![Newrelic Kuberneter Integration Clusters](images/07-newrelic-pixie.png?raw=true "Newrelic Kuberneter Integration Clusters")
