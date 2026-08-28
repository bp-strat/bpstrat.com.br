# Backfill no Airflow 3

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/data-engineering/apache-airflow/airflow-3-trouxe-o-run-backfill-para-o-centro-do-jogo.html

---

# Backfill no Airflow 3: Controles e Limites
{: .no_toc }


## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Backfill é a criação de DAG Runs para datas passadas. No Airflow 3, a operação pode ser iniciada pela CLI, pela API REST e pela interface. Isso centraliza o estado do reprocessamento, mas não torna as tasks idempotentes nem garante recuperação automática depois de qualquer interrupção.

A [documentação oficial de Backfill](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/backfill.html) limita o recurso a DAGs com agenda baseada em tempo. O intervalo informado é interpretado segundo o calendário do DAG.

![](/assets/5040c528c5388fc9d74538ad54225fd7_MD5.png)

## Políticas de reprocessamento

O comportamento depende do estado das execuções existentes para cada data lógica:

- `none`: não cria outra execução quando já existe um DAG Run para a data, independentemente do estado;
- `failed`: cria uma execução quando o DAG Run mais recente daquela data falhou;
- `completed`: cria uma execução quando o DAG Run mais recente terminou com sucesso ou falha.

Na interface, essas opções aparecem como **Missing Runs**, **Missing and Errored Runs** e **All Runs**. Se a execução mais recente ainda estiver em estado `running` ou `queued`, o Airflow não cria outra para a mesma data, qualquer que seja a política escolhida.

Essas políticas tratam DAG Runs, não a correção de tasks específicas. Quando apenas algumas tasks precisam ser executadas novamente, limpar as instâncias afetadas pode ser mais proporcional do que criar um novo backfill.

## Concorrência não é isolamento de capacidade

`max_active_runs` limita quantos DAG Runs daquele backfill podem ficar ativos ao mesmo tempo. Esse limite é aplicado separadamente do `max_active_runs` normal do DAG.

Separado não significa sem impacto. As execuções históricas continuam disputando workers, pools, conexões de banco, APIs, rede e armazenamento com outros workloads. Antes de escolher o valor, verifique:

- capacidade disponível nos pools e no executor;
- limites das fontes e destinos;
- volume processado por intervalo;
- duração e memória das tasks;
- efeito sobre os fluxos regulares;
- janela disponível para interromper o backfill se necessário.

## Interrupções e retomada

O estado do backfill e dos DAG Runs permite observar o que foi criado e concluído. Isso não sustenta a afirmação de que qualquer processamento interrompido será retomado automaticamente do ponto exato.

O resultado depende do componente que falhou e da implementação da task:

- uma task falhada só será repetida automaticamente dentro da política de retries configurada;
- um worker pode morrer depois de alterar um sistema externo e antes de registrar sucesso;
- uma task sem checkpoint pode reiniciar todo o intervalo;
- uma escrita não idempotente pode duplicar dados ou efeitos;
- credenciais, código ou dependências podem continuar indisponíveis depois que o scheduler voltar.

Depois de uma interrupção, examine DAG Runs e task instances em `queued`, `running` ou `failed`. Decida entre aguardar, limpar tasks, corrigir a causa ou criar um novo backfill. Essa decisão não deve ser delegada apenas ao estado exibido na interface.

## Versão do código e efeitos históricos

Aplicar uma regra nova ao passado exige saber qual versão do DAG e das dependências será executada. Também exige decidir se os resultados anteriores serão substituídos, versionados ou mantidos para auditoria.

Antes de reprocessar, confirme:

- versão do DAG, providers e bibliotecas;
- intervalo e timezone utilizados;
- disponibilidade das fontes históricas;
- destino e estratégia de sobrescrita;
- idempotência ou deduplicação;
- efeitos externos, como mensagens, cobranças e chamadas de APIs;
- validações de qualidade esperadas para cada partição.

## Faça uma simulação antes de criar execuções

A CLI oferece `--dry-run` para listar as datas consideradas. A criação efetiva ainda depende dos estados existentes no momento da execução.

```bash
airflow backfill create \
  --dag-id vendas_diarias \
  --from-date 2026-07-01 \
  --to-date 2026-07-05 \
  --reprocess-behavior failed \
  --max-active-runs 2 \
  --dry-run
```

Depois de revisar as datas, execute o mesmo comando sem `--dry-run`. Eu começaria com um intervalo pequeno e compararia o resultado antes de ampliar o período.

## Três decisões comuns

### Recuperar datas sem execução

Use a política correspondente a execuções ausentes e valide se a fonte histórica voltou a ficar disponível. O término do DAG não demonstra sozinho que todas as partições foram preenchidas.

### Recalcular uma regra de negócio

Use uma política que permita recriar execuções concluídas somente depois de definir versão do código, destino e reconciliação. Compare o resultado antigo com o novo antes de substituir dados usados por relatórios ou decisões.

### Corrigir falhas pontuais

Se o DAG Run falhou e precisa ser recriado, a política `failed` pode selecionar essas datas. Se apenas algumas tasks precisam repetir, avalie limpar as instâncias específicas para evitar trabalho e efeitos desnecessários.

## Critério de conclusão

Considere o backfill concluído quando:

- todas as datas esperadas foram criadas ou justificadamente ignoradas;
- DAG Runs e tasks terminaram nos estados previstos;
- contagens, partições e regras de qualidade foram reconciliadas;
- não houve duplicação de efeitos externos;
- o workload regular permaneceu dentro dos limites aceitos;
- falhas, intervenções e versões executadas ficaram registradas.

A interface melhora a operação e a rastreabilidade. A segurança do reprocessamento continua dependendo do desenho das tasks, da capacidade do ambiente e da validação dos dados produzidos.

## Referências

APACHE AIRFLOW. *Backfill*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/backfill.html](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/backfill.html)

APACHE AIRFLOW. *DAG Runs*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dag-run.html](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dag-run.html)
