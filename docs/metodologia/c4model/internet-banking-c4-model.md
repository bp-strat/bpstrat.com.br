# Exemplo Internet Banking

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/metodologia/c4model/internet-banking-c4-model.html

---

# Exemplo Internet Banking C4 Model
{: .no_toc }


## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

## Nível 1 — Diagrama de contexto

O primeiro diagrama mostra o Internet Banking como uma única unidade e identifica as pessoas e os sistemas externos com os quais ele se relaciona. Neste nível, ainda não são mostradas as aplicações internas.

```mermaid
C4Context
title Internet Banking — Contexto simplificado

Person(cliente, "Cliente", "Usuário do banco")
System(sistema, "Internet Banking", "Acessa contas e realiza pagamentos")

System_Ext(core, "Core Bancário", "Sistema principal do banco")
System_Ext(email, "Sistema de E-mail", "Envia notificações")

Rel(cliente, sistema, "Usa")
Rel(sistema, core, "Consulta dados e executa operações bancárias")
Rel(sistema, email, "Solicita o envio de notificações")
```

## Nível 2 — Diagrama de containers

Para ampliar o sistema, este exemplo assume duas aplicações executadas separadamente: uma aplicação web usada pelo cliente e uma API responsável pelos casos de uso. Também assume acesso por HTTPS e comunicação HTTPS/JSON entre essas aplicações. O Core Bancário e o Sistema de E-mail continuam fora da fronteira do Internet Banking.

Essas aplicações são hipóteses didáticas. O exemplo não inclui banco próprio, filas ou frameworks específicos porque essas decisões não estão presentes no material de origem.

```mermaid
C4Container
title Internet Banking — Containers do cenário didático

Person(cliente_container, "Cliente", "Usuário do banco")
System_Ext(core_container, "Core Bancário", "Sistema principal do banco")
System_Ext(email_container, "Sistema de E-mail", "Envia notificações")

System_Boundary(internet_banking, "Internet Banking") {
    Container(web, "Aplicação Web", "Aplicação cliente", "Apresenta contas, pagamentos e resultados ao cliente")
    Container(api, "API Internet Banking", "Aplicação server-side", "Executa os casos de uso e integra com sistemas externos")
}

Rel(cliente_container, web, "Acessa", "HTTPS")
Rel(web, api, "Solicita dados e operações", "HTTPS/JSON")
Rel(api, core_container, "Consulta dados e executa operações bancárias")
Rel(api, email_container, "Solicita o envio de notificações")

```

No modelo C4, um container representa uma aplicação ou um data store. Classes, módulos e serviços internos da API pertencem a um eventual diagrama de componentes, não a este nível.

## Limitações do exemplo

O diagrama não informa como autenticação, autorização, persistência local, auditoria, disponibilidade ou recuperação são implementadas. Essas decisões precisam ser adicionadas quando existirem requisitos ou evidências que as sustentem.

A sintaxe C4 do Mermaid ainda é marcada como experimental e pode mudar entre versões. O nível de abstração do diagrama deve permanecer o mesmo mesmo que a ferramenta de renderização seja substituída.

## Referências

- [C4 Model: diagrama de contexto](https://c4model.com/diagrams/system-context)
- [C4 Model: diagrama de containers](https://c4model.com/diagrams/container)
- [Mermaid: sintaxe para diagramas C4](https://mermaid.js.org/syntax/c4.html)
