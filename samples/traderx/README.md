Deploy the [finos/traderX](https://github.com/finos/traderX) with Score (`score-compose` and `score-k8s`).

```mermaid
flowchart TD
    dns[DNS] --> ingress(ingress)
    subgraph Workloads
        ingress-->reference-data(reference-data)
        ingress-->trade-service(trade-service)
        ingress-->trade-feed(trade-feed)
        ingress-->trade-processor(trade-processor)
        ingress-->web-frontend(web-frontend)
        ingress-->position-service(position-service)
        ingress-->people-service(people-service)
        ingress-->account-service(account-service)
        ingress-->database[(database)]
        web-frontend-->trade-feed
        web-frontend-->database
        account-service-->people-service
        account-service-->database
        position-service-->database
        trade-processor-->trade-feed
        trade-processor-->database
        trade-service-->account-service
        trade-service-->people-service
        trade-service-->reference-data
        trade-service-->trade-feed
    end
```

## Local deployment with Docker Compose

You need to be in the `samples/traderx` folder to run the following commands.

Deploy and test locally with Docker compose:
```bash
make compose-up
```

You can now browse http://localhost:8080.

## Local deployment with Kind cluster

Deploy and test locally with Kind cluster:
```bash
make kind-create-cluster

make k8s-up
```

You can now browse http://localhost:80.