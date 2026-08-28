# SDD Tático

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/metodologia/sdd/sdd-Spec-Driven-Development-tatica.html

---

# Spec-Driven Development: Tática
{: .no_toc }


## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}


![Diagrama do fluxo de Spec-Driven Development](/assets/slides-assets/sdd-diagram.png){: .rounded }


## Escopo deste fluxo

A [documentação oficial do Spec Kit](https://github.github.com/spec-kit/) define o fluxo principal como **Spec → Plan → Tasks → Implement**. Os comandos exatos podem variar conforme a versão e a integração com o agente. Verifique a instalação local com `specify integration list` antes de tratar este documento como instrução executável.

As etapas de pesquisa anterior à especificação e de preservação de aprendizados depois da entrega são extensões propostas neste documento. Elas não fazem parte do fluxo principal do Spec Kit.

## Workflow com fases interativas por feature

![Fluxo visual das fases interativas por feature no SDD](/assets/1f45ccbd61aaca931b20da8f35cb8843_MD5.png){: .rounded }

## Fase 0: Pesquisa, exploração e prototipagem

Esta é uma etapa anterior ao Spec Kit. Use-a quando ainda houver incerteza sobre o problema, as necessidades do usuário ou a viabilidade técnica. A pesquisa pode incluir documentação, código existente, alternativas e protótipos descartáveis.

O resultado não é software pronto nem uma especificação validada. É um conjunto rastreável de fatos, hipóteses, restrições e questões abertas que servirá de entrada para a especificação. Um artefato possível é uma *feature request* ou issue, por exemplo `feature-request-login-social.md`.

![Fluxo operacional do processo SDD](/assets/slides-assets/sdd-flow.png){: .rounded }

## Fase 1: Especificação (`/speckit.specify`)

O comando `/speckit.specify` gera uma especificação centrada no que precisa ser construído e por quê. Na configuração padrão descrita pelo projeto, ele cria uma branch e um diretório de feature com `spec.md`. Confirme esse comportamento na versão e na integração instaladas.

A especificação deve manter decisões de implementação fora dos requisitos, tornar critérios de sucesso verificáveis e deixar incertezas visíveis. Algumas versões e templates usam `[NEEDS CLARIFICATION: pergunta]`; o comando opcional `/speckit.clarify` ajuda a resolver áreas subespecificadas antes do planejamento.

Revise o arquivo gerado antes de continuar. A existência de `spec.md` não o transforma automaticamente em fonte da verdade: requisitos ainda podem estar incompletos, contraditórios ou diferentes da necessidade real.


## Fase 2: Planejamento técnico (`/speckit.plan`)

O comando `/speckit.plan` transforma a especificação em uma proposta de implementação. Dependendo do template e das necessidades da feature, os artefatos podem incluir `plan.md`, `research.md`, `data-model.md`, `quickstart.md` e arquivos em `contracts/`.

A constituição do projeto fornece critérios para avaliar o plano, mas não garante simplicidade, modularidade ou ausência de duplicação. Antes de aprovar, verifique:

- se cada decisão responde a um requisito;
- quais alternativas foram rejeitadas e por quê;
- se contratos e modelos são compatíveis com o sistema existente;
- quais riscos de segurança, migração e operação permanecem;
- como a implementação será testada e revertida.


## Fase 3: Detalhamento de tarefas (`/speckit.tasks`)

O comando `/speckit.tasks` decompõe o plano em `tasks.md`. Esta fase prepara o trabalho; ela não implementa a funcionalidade.

No formato padrão, `[P]` indica tarefas que podem ser executadas em paralelo porque não possuem dependência direta. Isso não significa que subagentes serão usados automaticamente nem que o paralelismo reduzirá tempo ou tokens. Confirme dependências, caminhos de arquivo, critérios de conclusão e pontos de integração antes de executar.

Quando disponíveis, `/speckit.checklist` pode apoiar a revisão dos requisitos e `/speckit.analyze` pode procurar inconsistências entre `spec.md`, `plan.md` e `tasks.md`. A análise também precisa ser revisada; ela não substitui os testes da implementação.


## Fase 4: Implementação (`/speckit.implement`)

O comando `/speckit.implement` orienta o agente a executar as tarefas. Para features grandes, limite cada execução a um subconjunto explícito de tarefas e revise o estado antes de continuar. A própria [documentação sobre features complexas](https://github.github.com/spec-kit/concepts/complex-features.html) alerta que agentes podem perder o plano ou ignorar tarefas quando uma implementação longa esgota o contexto.

O comando não garante aderência à especificação, segurança ou qualidade. Antes do merge, valide no mínimo:

- critérios de aceitação e testes automatizados relevantes;
- mudanças não previstas no plano;
- tratamento de dados, permissões e segredos;
- compatibilidade e migração;
- observabilidade e procedimento de rollback;
- revisão humana proporcional ao impacto da mudança.


## Fase 5: Arquivamento (`/archive`) — extensão deste fluxo

O arquivamento é uma etapa autoral deste modelo de SDD, posterior ao fluxo principal do Spec Kit. O comando customizado `speckit.archive.run` consolida os artefatos da feature e os aprendizados que devem permanecer disponíveis depois do merge. Ele não deve ser confundido com um comando padrão distribuído pelo Spec Kit.

O objetivo é reduzir a divergência entre a memória canônica do projeto e o que foi implementado. Para isso, a etapa deve:

- comparar `spec.md`, `plan.md` e `tasks.md` com a alteração integrada;
- registrar decisões que continuem válidas, desvios e limitações;
- preservar lições relevantes para manutenção ou reconstrução;
- atualizar os arquivos aplicáveis em `.specify/memory/`;
- vincular os registros ao pull request, aos testes e à especificação de origem;
- produzir um relatório com os caminhos alterados e pendências encontradas.

Antes de arquivar, confirme que o merge ocorreu e que as validações exigidas pelo projeto passaram. Depois, revise o relatório e o diff da memória. O comando melhora a rastreabilidade, mas não garante sozinho que a memória permaneça fiel ao código; mudanças futuras ainda precisam atualizar os artefatos correspondentes.





![Diagrama de referência sobre papéis e interações no SDD](/assets/slides-assets/sdd-rpi.png){: .rounded }

![Diagrama resumido do ciclo de Spec-Driven Development](/assets/slides-assets/sdd-diagram.png){: .rounded }
