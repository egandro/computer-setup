# Real Kubernetes

Documentation: <https://devopscube.com/kubernetes-cluster-vagrant/>


## Installation

You will need:

- vagrant
- vbox
- kubectl

```
git clone https://github.com/techiescamp/vagrant-kubeadm-kubernetes
cd vagrant-kubeadm-kubernetes
vagrant up
```

## Internal access

```
vagrant ssh master
kubectl top nodes
kubectl get po -n kube-system
kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/sample-app.yaml
# access via browser on node IP: http://10.0.0.11:32000
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
mkdir %USERPROFILE%\.kube
copy configs\config %USERPROFILE%\.kube
```

### Accessing k8s from host

```
kubectl get nodes
kubectl proxy
```

- browse to: <http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login>
- install openlens


## Volumes

- <https://kubernetes.io/docs/concepts/storage/persistent-volumes/>
- <https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/>



