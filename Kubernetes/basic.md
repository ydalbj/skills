##### Deploying an App
- 部署应用命令
```
$ kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
deployment.apps/kubernetes-bootcamp created
```

```
$ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   1/1     1            1           35s
```

- 查看应用

Pods运行在一个私有，隔离的网络上。对于同一个k8s集群的其他pods和services是可见的，对外是不可见的。
kubectl通过API endpoint与我们的应用交互。
kubectl命令可以创建一个代理，转发通信到集群私有网络
```
$ kubectl proxy
Starting to serve on 127.0.0.1:8001
```

然后可以通过代理与k8s集群交互

比如查看版本
```
curl http://localhost:8001/version
```
```
$ export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
$ echo Name of the Pod: $POD_NAME
Name of the Pod:
```

##### Explore App

- Kubernetes Pods
Pod是Kubernetes的抽象，代表一组一个或多个应用程序容器，和这些容器的一些共享资源。

```
kubectl get pods
kubectl describe pods
kubectl logs $POD_NAME
```

查看应用
```
 curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-5b48cfdcbd-kscfm |
```

执行命令
```
kubectl exec $POD_NAME env
kubectl exec -ti $POD_NAME bash
```
##### 使用Services公开您的应用

Kubernetes中的Services是一种抽象，定义了Pod的逻辑集合和访问Pod的策略。Services使依赖的Pod之间实现松散耦合。像所有Kubernetes对象一样，使用YAML（首选）或JSON定义服务。Services里的Pod集合通常由LabelSelector确定
