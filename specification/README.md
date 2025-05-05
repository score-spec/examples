## Initialize your local workspace

```bash
score-compose init
```

```bash
score-k8s init
```

## Generate the platform specific manifests

```bash
score-compose generate score.yaml --image busybox
```

```bash
score-k8s generate score.yaml --image busybox
```

## Deploy the generated manifests

```bash
docker compose up -d
```

```bash
kubectl apply -f manifests.yaml
```

## See the running containers

```bash
docker ps
```

```none
FIXME
```

```bash
kubectl get all
```

```none
FIXME
```