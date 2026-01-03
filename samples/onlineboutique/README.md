```bash
score-compose init --no-sample \
    --provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/service/score-compose/10-service.provisioners.yaml
```

```bash
score-compose generate \
    ad/score.yaml \
    cart/score.yaml \
    currency/score.yaml \
    email/score.yaml \
    payment/score.yaml \
    productcatalog/score.yaml \
    recommendation/score.yaml \
    shipping/score.yaml \
    checkout/score.yaml \
    frontend/score.yaml \
    loadgenerator/score.yaml
```

```bash
docker compose up --build -d --remove-orphans
```

```bash
curl $$(score-compose resources get-outputs dns.default#frontend.dns --format '{{ .host }}:8080')
```