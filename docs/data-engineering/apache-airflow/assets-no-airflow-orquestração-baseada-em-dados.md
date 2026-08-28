# Assets no Airflow

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/data-engineering/apache-airflow/assets-no-airflow-orquestra%C3%A7%C3%A3o-baseada-em-dados.html

---

# Assets no Airflow: dependências orientadas a dados
{: .no_toc }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Uma agenda cron responde à pergunta “quando executar?”. Um Asset permite
expressar outra condição: “execute depois que este dado for atualizado”. Isso é
útil quando o consumidor depende da conclusão do produtor, e não apenas de um
horário estimado.

## O que é um Asset

No Airflow, um Asset representa uma dependência de dados identificada por uma
URI. Exemplos possíveis incluem:

- `s3://dados/vendas/diarias.parquet`;
- `postgres://warehouse/public/vendas`;
- `file:///opt/airflow/data/entrada.csv`.

Os esquemas aceitos e suas validações dependem do core e dos providers
instalados. A URI identifica o Asset; ela não comprova que o arquivo ou a tabela
existe, está íntegro ou contém dados novos.

Não coloque credenciais, tokens nem outros valores sensíveis na URI ou no campo
`extra`. A documentação informa que esses dados são armazenados sem criptografia
no banco de metadados.

## O evento que dispara o consumidor

Declarar `Asset("s3://dados/arquivo.csv")` não faz o Airflow monitorar esse
arquivo. No fluxo entre DAGs, o evento é registrado quando uma task que declara o
Asset em `outlets` termina com sucesso. Um DAG agendado por esse mesmo Asset pode
então ser criado.

Isso cria uma responsabilidade importante: a task produtora só deve terminar
com sucesso depois de publicar e validar a saída. Caso contrário, o Airflow pode
registrar um evento mesmo que o dado esperado não esteja utilizável.

## Exemplo entre DAGs

O exemplo considera Airflow 3. O primeiro DAG publica o Asset; o segundo é
agendado por seu evento:

```python
from datetime import datetime, timezone

from airflow.sdk import Asset, DAG, task


vendas_diarias = Asset("s3://dados/vendas/diarias.parquet")


with DAG(
    dag_id="produzir_vendas_diarias",
    schedule="@daily",
    start_date=datetime(2026, 1, 1, tzinfo=timezone.utc),
    catchup=False,
):

    @task(outlets=[vendas_diarias])
    def produzir():
        gravar_e_validar_arquivo()

    produzir()


with DAG(
    dag_id="consumir_vendas_diarias",
    schedule=[vendas_diarias],
    start_date=datetime(2026, 1, 1, tzinfo=timezone.utc),
    catchup=False,
):

    @task
    def consumir():
        processar_arquivo()

    consumir()
```

As funções de escrita e processamento são placeholders. O exemplo demonstra a
relação de agendamento, não implementa acesso ao S3 nem validação de dados.

## Eventos externos

Quando o dado é atualizado fora de uma task do Airflow, declarar um `outlet` não
resolve a detecção. No Airflow 3, as opções documentadas incluem:

- o sistema externo publicar um evento pela API do Airflow;
- um `AssetWatcher` compatível observar a fonte externa;
- um DAG ou sensor detectar a mudança e emitir o evento do Asset.

A escolha depende da capacidade da fonte de emitir eventos, da latência
aceitável e do custo de polling. Um watcher exige trigger compatível com
agendamento orientado a eventos; um sensor periódico continua sendo polling.

## Limites operacionais e de segurança

Assets melhoram a rastreabilidade da dependência, mas não transportam o dado e
não garantem qualidade, unicidade ou processamento exatamente uma vez. Antes de
adotar esse agendamento, defina:

- qual operação representa uma atualização válida;
- como eventos duplicados serão tratados;
- qual partição ou versão foi publicada;
- como reconciliar evento registrado sem dado válido;
- quem pode criar eventos para o Asset;
- como recuperar eventos ausentes ou consumidores falhados.

No modelo de segurança documentado pelo Airflow, criar um evento pode disparar
DAGs consumidores. Em ambientes com múltiplas equipes, a permissão para criar
Assets e eventos deve ser tratada como permissão de provocar execução downstream.

## Critério de adoção

Use Assets quando a atualização do dado for uma fronteira de dependência mais
precisa do que o relógio. Mantenha uma agenda temporal quando o horário for a
regra real de negócio ou quando não existir um evento confiável. Antes de migrar,
teste um produtor e um consumidor, falhe o produtor intencionalmente e confirme
que nenhum evento incorreto foi emitido.

## Referências

APACHE AIRFLOW. *Asset-Aware Scheduling*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/asset-scheduling.html](https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/asset-scheduling.html)

APACHE AIRFLOW. *Asset Definitions*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/assets.html](https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/assets.html)

APACHE AIRFLOW. *Event-driven scheduling*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/event-scheduling.html](https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/event-scheduling.html)
