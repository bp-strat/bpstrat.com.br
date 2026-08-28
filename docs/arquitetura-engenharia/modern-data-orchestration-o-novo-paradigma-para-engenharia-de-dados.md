# Quando Adotar Orquestração de Dados

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/arquitetura-engenharia/modern-data-orchestration-o-novo-paradigma-para-engenharia-de-dados.html

---

# Quando Adotar Orquestração de Dados
{: .no_toc }


## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Um job agendado pode ser suficiente enquanto o fluxo possui poucas etapas e uma recuperação simples. A necessidade de um orquestrador dedicado aparece quando dependências, reprocessamentos, concorrência e falhas deixam de ser controláveis pelo mecanismo existente.

“Orquestração moderna” não define uma arquitetura específica. Neste documento, o termo significa coordenar a execução de trabalhos, registrar seus estados e oferecer mecanismos operacionais para decidir o que pode executar, repetir ou interromper.

![](/assets/4328679e722cd29ff283ac8fd5cfd466_MD5.png){: .rounded }

## O que um orquestrador faz

Um orquestrador representa trabalhos e suas dependências, dispara execuções por agenda ou evento e acompanha o estado de cada etapa. Dependendo da ferramenta, também oferece políticas de repetição, timeout, concorrência, reprocessamento, logs e interface operacional.

A [visão de arquitetura do Apache Airflow](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/overview.html), por exemplo, separa DAGs, tasks, scheduler, executor, workers e banco de metadados. O DAG define como executar e ordenar as tarefas; o trabalho de transformar ou mover dados continua dentro das próprias tarefas e dos sistemas chamados por elas.

## Quando eu consideraria um orquestrador dedicado

O investimento tende a fazer sentido quando vários destes sinais aparecem juntos:

- um trabalho depende do resultado de outros e essa relação precisa ficar explícita;
- falhas exigem repetição seletiva, timeout ou retomada controlada;
- o time precisa reprocessar intervalos históricos;
- limites de concorrência protegem bancos, APIs ou capacidade computacional;
- diferentes equipes precisam consultar estado, logs e histórico de execução;
- jobs espalhados por vários agendadores dificultam diagnóstico e ownership;
- o atraso ou a falha de um fluxo possui consequência operacional conhecida.

Para um único script idempotente, com execução periódica e recuperação manual aceitável, cron ou o agendador nativo da plataforma pode ter menor custo. Um sistema dirigido por eventos também pode usar filas e consumidores sem representar todo o fluxo em um orquestrador central.

## O que a orquestração não garante

### Qualidade dos dados

Uma task concluída com sucesso demonstra apenas que sua execução terminou segundo o contrato implementado. Precisão, completude e atualização dos dados exigem validações próprias, critérios de aceitação e tratamento explícito de resultados inválidos.

### Observabilidade

Estado de tasks e logs ajudam a investigar o fluxo, mas não substituem métricas da infraestrutura, qualidade dos dados, lineage ou observabilidade dos sistemas externos. Defina quais perguntas operacionais cada sinal precisa responder.

### Segurança e compliance

RBAC, criptografia e integração com gerenciadores de segredos são capacidades que precisam ser configuradas e testadas. Centralizar a operação também cria um componente com acesso a vários sistemas; permissões excessivas ampliam o impacto de uma falha ou credencial comprometida.

### Escalabilidade e alta disponibilidade

Kubernetes e containers não tornam pipelines automaticamente elásticos ou disponíveis. Scheduler, banco de metadados, executor, workers e serviços externos possuem limites diferentes. A própria [documentação do scheduler do Airflow](https://airflow.apache.org/docs/apache-airflow/stable/concepts/scheduler.html) recomenda observar CPU, memória, rede, banco e estrutura dos DAGs antes de ajustar capacidade.

### Ambientes híbridos e multicloud

Executar tarefas em ambientes diferentes pode ser necessário, mas acrescenta identidade, rede, egress, latência e modos de falha. Multi-cloud é uma restrição a administrar, não um benefício automático da orquestração.

## Critérios para escolher uma solução

Antes de comparar ferramentas, registre:

| Critério | Pergunta operacional |
|---|---|
| Modelo de execução | Batch, evento, streaming ou combinação? |
| Recuperação | O que deve ser repetido e quais efeitos precisam ser idempotentes? |
| Escala | Quantos workflows, tasks concorrentes e execuções por período? |
| Dependências | Quais sistemas limitam concorrência ou disponibilidade? |
| Segurança | Quais credenciais cada task pode acessar? |
| Operação | Quem mantém scheduler, banco, workers, upgrades e plantão? |
| Evidência | Quais logs, métricas e históricos são exigidos? |
| Custo | Qual o custo de infraestrutura, serviço gerenciado e manutenção? |

Avalie também o modelo operacional. Uma instalação autogerenciada oferece controle e transfere para a equipe backups, upgrades, monitoramento e recuperação. Um serviço gerenciado reduz parte desse trabalho, mas acrescenta custo recorrente, limites do fornecedor e requisitos de integração.

## Experimento inicial

Eu começaria com dois ou três workflows representativos, incluindo pelo menos uma falha e um reprocessamento. Antes do teste, estabeleceria uma linha de base do mecanismo atual.

Durante o experimento, mediria:

- tempo para detectar e recuperar uma falha;
- intervenções manuais por execução;
- atraso entre o horário esperado e o início real;
- reprocessamentos concluídos sem efeitos duplicados;
- falhas não detectadas pelos alertas;
- tempo gasto em implantação, atualização e operação;
- custo da infraestrutura ou do serviço.

Adote a plataforma quando a melhora nesses critérios justificar o novo componente e sua carga operacional. Caso o fluxo permaneça simples, manter um agendador menor pode ser a decisão mais proporcional.
