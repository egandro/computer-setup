# Real Kubernetes

Documentation: <https://devopscube.com/kubernetes-cluster-vagrant/>


## Installation

```
git clone https://github.com/techiescamp/vagrant-kubeadm-kubernetes
cd vagrant-kubeadm-kubernetes
vagrant up
```

## Internal access:

```
vagrant ssh master
kubectl top nodes
kubectl get po -n kube-system
kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/sample-app.yaml
vagrant halt
vagrant up
vagrant destroy
```

## External access

### Linux

```
mkdir -p $HOME/.kube
cp configs/config $HOME/.kube
```

### Windows

```
mkdir %USER%\.kube
cd config
robocopy config %USER%\.kube /s /e
```

### Accessing k8s from host

```
kubectl get nodes
kubectl proxy
```

Browse to: <http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login>





