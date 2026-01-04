```bash
score-compose init --no-sample \
    --provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/service/score-compose/10-service.provisioners.yaml \
    --provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/llm-model/score-compose/10-dmr-llm-model.provisioners.yaml
```

```bash
score-compose generate \
    order/score.yaml \
    ai/score.yaml \
    product-ai/score.yaml \
    store-front/score.yaml \
    store-admin/score.yaml \
    makeline/score.yaml
```

```bash
docker compose up --build -d --remove-orphans
```

```bash
curl $(score-compose resources get-outputs dns.default#store-front.dns --format '{{ .host }}:8080')
curl $(score-compose resources get-outputs dns.default#store-admin.dns --format '{{ .host }}:8080')
```