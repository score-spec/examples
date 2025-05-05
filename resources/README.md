## Initialize your local workspace

This will use the default provisioner, you can use other provisioners instead like explained here-FIXME.

```bash
score-commpose init
```

```bash
score-k8s init
```

## Get the provisioner definition

```bash
score-compose provisioners list
```

```bash
score-k8s provisioners list
```

## Generate the platform specific manifests

```bash
score-commpose generate score.yaml
```

```bash
score-k8s generate score.yaml
```

## See the resource outputs

```bash
score-commpose resources list

score-compose resources get-outputs FIXME
```

```bash
score-k8s resources list

score-k8s resources get-outputs FIXME
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