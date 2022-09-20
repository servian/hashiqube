# Minikube
This page shows you how to install Minikube, a tool that runs a single-node Kubernetes cluster in a virtual machine on your personal computer.
https://kubernetes.io/docs/tasks/tools/install-minikube/
https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

## Minikube usage

You should have done `vagrant up --provision` This sets up the base Virtual machine, with some default applications.
Now please do,
`vagrant up --provision-with minikube`
```
Bringing machine 'user.local.dev' up with 'virtualbox' provider...
==> user.local.dev: Checking if box 'ubuntu/xenial64' version '20190918.0.0' is up to date...
==> user.local.dev: A newer version of the box 'ubuntu/xenial64' for provider 'virtualbox' is
==> user.local.dev: available! You currently have version '20190918.0.0'. The latest is version
==> user.local.dev: '20191204.0.0'. Run `vagrant box update` to update.
==> user.local.dev: [vagrant-hostsupdater] Checking for host entries
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: [vagrant-hostsupdater]   found entry for: 10.9.99.10 user.local.dev
==> user.local.dev: Running provisioner: minikube (shell)...
    user.local.dev: Running: /var/folders/7j/gsrjvmds05n53ddg28krf4_80001p9/T/vagrant-shell20191212-33841-85girj.sh
    user.local.dev: Minicube found at /home/vagrant/minikube
    user.local.dev: * Uninstalling Kubernetes v1.17.0 using kubeadm ...
    user.local.dev: * Deleting "minikube" in none ...
    user.local.dev: * The "minikube" cluster has been deleted.
    user.local.dev: * Trying to delete invalid profile minikube
    user.local.dev: * Successfully deleted profile "minikube"
    user.local.dev: * minikube v1.6.1 on Ubuntu 16.04 (vbox/amd64)
    user.local.dev: * Selecting 'none' driver from user configuration (alternates: [])
    user.local.dev: * Running on localhost (CPUs=2, Memory=3951MB, Disk=9861MB) ...
    user.local.dev: * OS release is Ubuntu 16.04.6 LTS
    user.local.dev: * Preparing Kubernetes v1.17.0 on Docker '19.03.5' ...
    user.local.dev:   - kubelet.node-ip=10.9.99.10
    user.local.dev: * Pulling images ...
    user.local.dev: * Launching Kubernetes ...
    user.local.dev: E1212 05:37:03.427248   10726 kubeadm.go:368] Overriding stale ClientConfig host https://localhost:8443 with https://10.0.2.15:8443
    user.local.dev: * Configuring local host environment ...
    user.local.dev: *
    user.local.dev:   - https://minikube.sigs.k8s.io/docs/reference/drivers/none/
    user.local.dev: *
    user.local.dev: *
    user.local.dev:   - sudo mv /home/vagrant/.kube /home/vagrant/.minikube $HOME
    user.local.dev:   - sudo chown -R $USER $HOME/.kube $HOME/.minikube
    user.local.dev: *
    user.local.dev: * This can also be done automatically by setting the env var CHANGE_MINIKUBE_NONE_USER=true
    user.local.dev: * Waiting for cluster to come online ...
    user.local.dev: ! The 'none' driver provides limited isolation and may reduce system security and reliability.
    user.local.dev: ! For more information, see:
    user.local.dev: ! kubectl and minikube configuration will be stored in /home/vagrant
    user.local.dev: ! To use kubectl or minikube commands as your own user, you may need to relocate them. For example, to overwrite your own settings, run:
    user.local.dev: E1212 05:37:03.517401   10726 kubeadm.go:368] Overriding stale ClientConfig host https://localhost:8443 with https://10.0.2.15:8443
    user.local.dev: * Done! kubectl is now configured to use "minikube"
    user.local.dev: chmod: changing permissions of 'kubectl': Operation not permitted
    user.local.dev: * minikube IP has been updated to point at 10.0.2.15
    user.local.dev: W1212 05:37:16.080458   14080 proxy.go:142] Request filter disabled, your proxy is vulnerable to XSRF attacks, please be cautious
    user.local.dev: Starting to serve on 10.9.99.10:10888
    user.local.dev: host:
    user.local.dev: Running
    user.local.dev: kubelet: Running
    user.local.dev: apiserver: Running
    user.local.dev: kubeconfig: Configured
    user.local.dev: NAME       STATUS   ROLES    AGE   VERSION
    user.local.dev: minikube   Ready    master   16s   v1.17.0
    user.local.dev: deployment.apps/hello-minikube created
    user.local.dev: service/hello-minikube exposed
    user.local.dev: http://10.0.2.15:30664
    user.local.dev: NAME
    user.local.dev:                               READY   STATUS    RESTARTS   AGE
    user.local.dev: hello-minikube-797f975945-sr9gg   0/1     Pending   0          0s
    user.local.dev: minikube dashboard: http://10.9.99.10:10888/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/overview?namespace=default
```    
Let's verify that our Minikube is running, we can go to the Dashboard by visiting in your browser:
http://10.9.99.10:10888/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/overview?namespace=kubernetes-dashboard
![Minikube](images/minikube.png?raw=true "Minikube")

From your computer you can interact with kubectl by using `vagrant ssh -c "sudo kubectl command"`
Like so:
`vagrant ssh -c "sudo kubectl get nodes"`                                           

```
NAME       STATUS   ROLES    AGE   VERSION
minikube   Ready    master   59m   v1.17.0
Connection to 127.0.0.1 closed.
```

`vagrant ssh -c "sudo kubectl get deployments"`

```
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
hello-minikube   1/1     1            1           59m
Connection to 127.0.0.1 closed.
```

`vagrant ssh -c "sudo kubectl get services"`

```
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
hello-minikube   NodePort    10.96.216.129   <none>        10800:30091/TCP   59m
kubernetes       ClusterIP   10.96.0.1       <none>        443/TCP           60m
Connection to 127.0.0.1 closed.
```

Or you can SSH into the VM by doing `vagrant ssh` and then using `sudo` do:
`sudo kubectl get nodes`

```
NAME       STATUS   ROLES    AGE   VERSION
minikube   Ready    master   63m   v1.17.0
```

## K9s for Minikube (CLI alternative to kubectl)
k9s is a CLI tool for interacting with k8s clusters. It wraps kubectl functionality to provide a terminal interface for interaction with clusters in an intuitive way. 

With the minikube installation k9s is also installed on the Vagrant machine. To run, after provisioning minikube run the following commands:
```
ssh vagrant
k9s
```
You should be greeted with the following in your terminal:
![k9s](images/k9s_screenshot1.png?raw=true "k9s")

Press "0" to display all namespaces. 
![k9s_2](images/k9s_screenshot2.png?raw=true "k9s_2")
### Helpful k9s tips
- Press ":" to bring up command prompt. You can enter commands to change screens. e.g. "deployments" takes you to list of deployments.
- You can navigate around with arrow keys then press buttons as listed in the top right to interact with the highlighted item. e.g "l" to show logs of selected pod. 
- For full instructions and preview video see the k9s website: https://k9scli.io/
  

## Traefik on Minikube
https://doc.traefik.io/traefik/v1.7/user-guide/kubernetes/

This guide explains how to use Traefik as an Ingress controller for a Kubernetes cluster.

![Traefik on Minikube](images/minikube-traefik-dashboard.png?raw=true "Traefik on Minikube")