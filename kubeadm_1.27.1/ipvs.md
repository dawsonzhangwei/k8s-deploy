#加载完成后，修改configmap并删除kube-proxy即可完成，在Master节点修改

##修改configmap
kubectl edit -n kube-system cm kube-proxy //将mode: " "修改为mode: “ipvs”，:wq保存退出

##查看kube-system命名空间下的kube-proxy并删除，删除后，k8s会自动再次生成，新生成的kube-proxy会采用刚刚配置的ipvs模式
kubectl get pod -n kube-system
kubectl get pod -n kube-system |grep kube-proxy |awk '{system("kubectl delete pod "$1" -n kube-system")}'