# bpStack

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/servicos/bpstack.html

---

# bpStack
{: .no_toc }

Um mapa vivo do portfólio técnico para empresas que precisam conectar produtos, repositórios, arquitetura, dependências e planos de versão sem criar mais uma camada de microgestão.
{: .fs-6 .fw-300 }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

O **bpStack** é uma plataforma em beta controlado da BP STRAT para apoiar consultorias, lideranças técnicas e organizações com múltiplos repositórios, produtos digitais e dependências arquiteturais pouco visíveis.

Ele foi desenhado para responder uma pergunta simples: **o que existe no portfólio técnico, como as partes se conectam e qual contexto precisa estar disponível para decisões humanas e agentes de IA?**

## O problema

Empresas com dezenas de repositórios frequentemente perdem clareza sobre:

- quais produtos existem
- quais projetos sustentam cada produto
- quais repositórios fazem parte de cada frente
- quem depende de quem
- quais tecnologias são realmente usadas
- quais riscos, dúvidas e decisões estão abertos
- quais itens estão previstos em uma versão
- qual contexto técnico deve ser entregue para agentes de IA trabalharem com segurança

Essa falta de visão cria dependência excessiva de pessoas específicas, aumenta o custo de onboarding, enfraquece decisões arquiteturais e dificulta priorização técnica.

## O que é

bpStack é um gestor minimalista de portfólio técnico.

Ele conecta:

- produtos
- projetos e repositórios
- arquitetura C4 até visão de containers
- dependências entre projetos
- stack tecnológica observada
- comentários, riscos, dúvidas e decisões
- planos de versão
- contexto para agentes via MCP

O objetivo não é substituir ferramentas de execução. O bpStack atua como uma camada de inventário, navegação e contexto para decisões técnicas.

## O que organiza

No modelo atual, a hierarquia principal é:

```text
Cliente
└── Produto
    └── Projeto
        └── Repositório
        └── Sistema C4
            └── Containers
```

A plataforma permite relacionar produtos, projetos, arquitetura declarada, tecnologias e planos de evolução em uma visão comum para liderança, arquitetura e engenharia.

## Como funciona no beta

O beta trabalha com uso assistido e escopo controlado.

O fluxo típico é:

1. A organização define produtos e projetos relevantes.
2. Cada projeto recebe metadados essenciais e, quando disponível, um `workspace.dsl`.
3. O bpStack processa a arquitetura declarada via C4 Parser Service.
4. A plataforma renderiza visualizações de contexto e containers.
5. Tecnologias, relações, anotações e planos de versão passam a compor o mapa do portfólio.
6. O contexto pode ser consultado por humanos e por agentes via MCP read-only.

## O que está no beta

- Cadastro de produtos e projetos
- Ingestão de Structurizr DSL por projeto
- Integração com C4 Parser Service
- Visualização C4 até Container View
- Links entre projetos quando a arquitetura declara chaves estáveis
- Stack Radar inicial
- Comentários, riscos, dúvidas e decisões
- Planos de versão simples
- MCP Server read-only para contexto técnico
- Instrumentação com OpenTelemetry para operações críticas

## O que não é

O bpStack não pretende virar:

- Jira
- Kanban
- sprint board
- task tracker
- SonarQube
- CMDB pesada
- Structurizr completo
- ferramenta genérica de diagramas

Essa escolha é deliberada. A plataforma existe para dar clareza de portfólio técnico, não para controlar a execução diária dos times.

## Para quem é

- Empresas com 20 a 60 repositórios ou mais
- CTOs e Heads de Engenharia que precisam de visão de portfólio
- Arquitetos que precisam conectar sistemas, containers e dependências
- Consultorias que precisam diagnosticar ambientes técnicos rapidamente
- Times que querem preparar contexto confiável para agentes de IA

## Como entra em uma consultoria

O bpStack pode apoiar diagnósticos e programas de evolução técnica como uma camada de evidência.

Ele ajuda a:

- acelerar leitura de ambiente
- reduzir entrevistas repetitivas sobre sistemas e dependências
- registrar decisões e riscos junto ao contexto técnico
- conectar arquitetura com plano de versão
- tornar o contexto mais reutilizável por agentes e especialistas

## Acesso beta

O acesso ao beta é controlado e indicado para organizações que aceitam começar com um recorte do portfólio técnico.

O ponto de partida recomendado é escolher um produto, seus principais projetos e um conjunto pequeno de repositórios para mapear dependências, arquitetura e plano de evolução.

[Conversar sobre o beta do bpStack. →](/contato.html){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
