# OnlineBoutique

```mermaid
flowchart TD
    dns[DNS] --> frontend(frontend)
    subgraph Workloads
        loadgenerator(loadgenerator)-->frontend
        frontend-->recommendation(recommendation)
        frontend-->ad(ad)
        frontend-->shipping(shipping)
        frontend-->currency(currency)
        frontend-->checkout(checkout)
        frontend-->cart(cart)
        checkout-->cart
        checkout-->payment(payment)
        checkout-->email(email)
        checkout-->currency
        checkout-->productcatalog(productcatalog)
        recommendation-->productcatalog
        frontend-->productcatalog
    end
    cart-->redis[(Redis)]
```

Deploy the [GoogleCloudPlatform/microservices-demo](https://github.com/GoogleCloudPlatform/microservices-demo) with Score:

- [`score-compose`](./score-compose.md)
- [`score-k8s`](./score-k8s.md)