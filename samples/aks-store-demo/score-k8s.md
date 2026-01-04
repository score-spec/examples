```bash
score-k8s init --no-sample \
    --provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/service/score-k8s/10-service.provisioners.yaml
```

```bash
score-k8s generate \
    order/score.yaml \
    product/score.yaml \
    store-front/score.yaml \
    store-admin/score.yaml \
    makeline/score.yaml
```

```bash
kubectl apply -f manifests.yaml
```

```bash
curl $$(score-k8s resources get-outputs dns.default#store-front.dns --format '{{ .host }}:80')
```