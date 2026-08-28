# Exemplo Shipping

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/metodologia/c4model/shipping-c4-model.html

---

# Shipping no C4: containers e componentes
{: .no_toc }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Esta página complementa o exemplo de [modelagem do domínio Shipping](/docs/ddd/ddd-modeling-shipping-postgresql.html) com uma visão de arquitetura no modelo C4. O objetivo é mostrar a progressão entre containers e componentes sem transformar camadas de código em unidades de execução.

Os diagramas representam um **cenário hipotético**, não uma arquitetura observada em produção. Tecnologias, protocolos e fronteiras foram escolhidos para tornar o exemplo concreto e precisam ser validados contra requisitos reais antes de orientar uma implementação.

## Hipóteses do cenário

Para este exemplo, assumimos quatro unidades operacionais dentro do sistema de Shipping:

- **Shipping API:** aplicação HTTP executada e publicada como uma unidade;
- **Shipping Worker:** aplicação assíncrona executada separadamente da API;
- **Shipping DB:** data store PostgreSQL compartilhado pela API e pelo Worker;
- **Event Bus:** fila ou tópico acessível pelas duas aplicações.

A Carrier API permanece um sistema externo. O cenário assume que o Worker solicita operações ao carrier e que o carrier envia mudanças de tracking para um webhook da Shipping API.

`Application Services`, `ShippingOrder Aggregate`, repositories e adapters não são containers neste cenário. Eles executam dentro da API ou do Worker e aparecem somente nos diagramas de componentes.

## Nível 2 — Containers

Um container no C4 representa uma aplicação ou um data store. O diagrama abaixo mostra unidades executáveis e seus relacionamentos; ele não mostra classes, módulos, réplicas ou nós de infraestrutura.

```mermaid
C4Container
title Sistema de Shipping — Containers do cenário hipotético

Person(user, "Cliente ou operador", "Solicita e consulta operações de envio")
System_Ext(carrier, "Carrier API", "Provedor logístico externo")

System_Boundary(shipping, "Sistema de Shipping") {
    Container(api, "Shipping API", "Python, FastAPI", "Expõe operações HTTP, executa casos de uso e recebe webhooks")
    Container(worker, "Shipping Worker", "Python, worker assíncrono", "Consome eventos e executa integrações com o carrier")
    ContainerDb(db, "Shipping DB", "PostgreSQL", "Mantém o estado atual de ShippingOrder")
    ContainerQueue(queue, "Event Bus", "Fila ou tópico", "Transporta eventos usados pelo processamento assíncrono")
}

Rel(user, api, "Executa operações de envio", "HTTPS/JSON")
Rel(api, db, "Lê e escreve o estado do envio", "SQL")
Rel(api, queue, "Publica eventos de Shipping", "Mensageria")
Rel(worker, queue, "Consome eventos de Shipping", "Mensageria")
Rel(worker, carrier, "Solicita operações de transporte", "HTTPS/JSON")
Rel(worker, db, "Registra resultados da integração", "SQL")
Rel(carrier, api, "Notifica mudanças de tracking", "Webhook HTTPS/JSON")
```

O Event Bus aparece dentro da fronteira porque o cenário o trata como parte do sistema de Shipping. Se a mensageria for uma plataforma externa administrada por outra equipe, sua fronteira e sua responsabilidade devem ser representadas de outra forma.

## Nível 3 — Componentes da Shipping API

Este diagrama amplia somente o container **Shipping API**. Shipping DB, Event Bus, usuário e Carrier API aparecem como elementos de apoio porque se relacionam diretamente com componentes da API.

```mermaid
C4Component
title Shipping API — Componentes

Person(user_api, "Cliente ou operador", "Solicita e consulta operações de envio")
System_Ext(carrier_api, "Carrier API", "Provedor logístico externo")

Container_Boundary(api_boundary, "Shipping API") {
    Component(http_endpoint, "Shipping HTTP Endpoint", "FastAPI", "Valida contratos HTTP e aciona casos de uso")
    Component(webhook_endpoint, "Carrier Webhook Endpoint", "FastAPI", "Recebe e valida notificações do carrier")
    Component(application_service, "Shipping Application Service", "Python", "Coordena casos de uso e transações")
    Component(aggregate, "ShippingOrder Aggregate", "Modelo de domínio", "Aplica regras e transições do envio")
    Component(repository, "Shipping Repository Adapter", "SQLAlchemy", "Persiste e recupera ShippingOrder")
    Component(event_publisher, "Shipping Event Publisher", "Adapter de mensageria", "Publica eventos para processamento assíncrono")
}

ContainerDb(db_api, "Shipping DB", "PostgreSQL", "Mantém o estado atual de ShippingOrder")
ContainerQueue(queue_api, "Event Bus", "Fila ou tópico", "Recebe eventos publicados pela API")

Rel(user_api, http_endpoint, "Executa operações de envio", "HTTPS/JSON")
Rel(carrier_api, webhook_endpoint, "Envia mudanças de tracking", "Webhook HTTPS/JSON")
Rel(http_endpoint, application_service, "Aciona caso de uso")
Rel(webhook_endpoint, application_service, "Aciona atualização de tracking")
Rel(application_service, aggregate, "Executa comportamento do domínio")
Rel(application_service, repository, "Carrega e persiste o aggregate")
Rel(application_service, event_publisher, "Solicita publicação")
Rel(repository, db_api, "Lê e escreve", "SQL")
Rel(event_publisher, queue_api, "Publica eventos", "Mensageria")
```

O diagrama mostra responsabilidades, não a ordem temporal de uma requisição. Se a sequência entre persistir o aggregate e publicar o evento for relevante, um diagrama dinâmico e a estratégia de consistência devem complementar esta visão.

## Nível 3 — Componentes do Shipping Worker

O segundo diagrama amplia somente o container **Shipping Worker**. Mesmo que API e Worker compartilhem bibliotecas no código-fonte, eles continuam sendo aplicações distintas no cenário porque possuem processos e ciclos de execução próprios.

```mermaid
C4Component
title Shipping Worker — Componentes

System_Ext(carrier_worker, "Carrier API", "Provedor logístico externo")

Container_Boundary(worker_boundary, "Shipping Worker") {
    Component(event_handler, "Shipping Event Handler", "Consumer", "Recebe eventos e inicia o processamento")
    Component(integration_service, "Carrier Integration Service", "Python", "Coordena a operação solicitada ao carrier")
    Component(carrier_adapter, "Carrier API Adapter", "HTTP client", "Traduz chamadas e respostas do carrier")
    Component(worker_repository, "Shipping Repository Adapter", "SQLAlchemy", "Registra o resultado da integração")
}

ContainerDb(db_worker, "Shipping DB", "PostgreSQL", "Mantém o estado atual de ShippingOrder")
ContainerQueue(queue_worker, "Event Bus", "Fila ou tópico", "Disponibiliza eventos para o Worker")

Rel(event_handler, queue_worker, "Consome eventos", "Mensageria")
Rel(event_handler, integration_service, "Inicia integração")
Rel(integration_service, carrier_adapter, "Solicita operação")
Rel(carrier_adapter, carrier_worker, "Chama o carrier", "HTTPS/JSON")
Rel(integration_service, worker_repository, "Registra resultado")
Rel(worker_repository, db_worker, "Lê e escreve", "SQL")
```

O exemplo não determina se regras de domínio são compartilhadas como biblioteca, reimplementadas ou chamadas por outro contrato. Essa decisão precisa preservar as invariantes de `ShippingOrder` e evitar que o Worker faça atualizações incompatíveis com a API.

## O que os diagramas não garantem

Os relacionamentos mostram dependências, mas não demonstram propriedades operacionais. Antes de usar esta topologia em produção, ainda seria necessário decidir e testar:

- consistência entre a transação no PostgreSQL e a publicação no Event Bus;
- idempotência, retries, ordenação, dead-letter queue e tratamento de mensagens duplicadas;
- autenticação do webhook e proteção contra replay;
- permissões distintas para API e Worker no banco e na mensageria;
- timeouts, circuit breaking e limites de chamadas ao carrier;
- observabilidade e correlação entre requisição, evento e integração;
- recuperação quando banco, broker ou carrier estiverem indisponíveis.

O banco compartilhado simplifica algumas transações, mas também acopla API e Worker ao mesmo schema e ao mesmo ciclo de migração. Separá-lo só seria justificável diante de requisitos de ownership, escala, segurança ou disponibilidade que compensassem o custo de sincronização.

Réplicas, clusters, zonas, processos e infraestrutura pertencem a um diagrama de deployment. Eles não devem ser inferidos a partir destes diagramas de containers e componentes.

## Como adaptar o exemplo

Ao documentar uma arquitetura real:

1. confirme quais elementos são aplicações ou data stores executáveis;
2. registre quem possui e opera cada elemento;
3. identifique protocolos e tecnologias observados, sem preencher lacunas por convenção;
4. crie um diagrama de componentes separado para cada container que realmente precise desse nível de detalhe;
5. registre limitações e decisões de consistência fora do diagrama quando a notação não for suficiente.

## Referências

- [C4 Model: diagrama de containers](https://c4model.com/diagrams/container)
- [C4 Model: diagrama de componentes](https://c4model.com/diagrams/component)
- [C4 Model: diagrama de deployment](https://c4model.com/diagrams/deployment)
- [Mermaid: sintaxe para diagramas C4](https://mermaid.js.org/syntax/c4.html)
