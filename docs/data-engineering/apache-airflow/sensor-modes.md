# Sensores

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/data-engineering/apache-airflow/sensor-modes.html

---

# Sensores no Airflow: Poke, Reschedule e Deferral
{: .no_toc }

Sensores aguardam uma condição externa. A decisão principal não é apenas quanto
tempo esperar, mas qual componente manterá essa espera e qual capacidade será
consumida.
{: .fs-6 .fw-300 }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

![](/assets/bff38b5b5f9dbd613279af1a9d9dae4d_MD5.jpg){: .rounded }

## Três estratégias de espera

O parâmetro `mode` de um `BaseSensorOperator` possui dois valores: `poke` e
`reschedule`. Deferral é uma capacidade adicional implementada por alguns
Operators e Sensors; não é um terceiro valor de `mode` disponível
automaticamente em todos eles.

| Estratégia | Durante a espera | Custo ou dependência |
|------------|------------------|----------------------|
| `mode="poke"` | mantém um worker slot ocupado | reduz latência entre checks, mas consome capacidade de execução |
| `mode="reschedule"` | libera o worker entre checks | cria ciclos de reagendamento pelo scheduler |
| implementação deferrable | transfere a espera para um trigger | exige suporte do provider e um triggerer operacional |

Não há um limite universal de minutos para escolher entre elas. Duração
esperada, latência tolerada, concorrência, custo do polling e capacidade do
ambiente precisam ser avaliados juntos.

## Poke

Em `poke`, o processo verifica a condição, aguarda `poke_interval` e verifica
novamente sem liberar o worker slot. Isso pode ser aceitável para baixa
concorrência e esperas realmente curtas, quando a resposta rápida justifica a
capacidade reservada.

O risco aparece quando muitos sensores permanecem ociosos em `poke`: tasks de
processamento podem ficar na fila mesmo que os workers estejam apenas esperando.
Pools separados limitam a competição, mas não removem o consumo de recursos.

## Reschedule

Em `reschedule`, uma verificação sem sucesso coloca a task em estado de espera e
libera o worker até o próximo check. Essa opção atende sensores clássicos que não
oferecem deferral e não devem reter capacidade durante uma espera prolongada.

O benefício tem custo: cada nova verificação volta a passar pelo scheduler e
pela execução da task. Um `poke_interval` agressivo pode aumentar carga no
scheduler, no metastore e no sistema consultado.

```python
from airflow.providers.standard.sensors.filesystem import FileSensor


aguardar_arquivo_local = FileSensor(
    task_id="aguardar_arquivo_local",
    fs_conn_id="fs_default",
    filepath="data/input/relatorio.csv",
    mode="reschedule",
    poke_interval=60,
    timeout=60 * 60,
)
```

O snippet pressupõe que está dentro de um DAG e que a Connection `fs_default`
existe. Os valores são ilustrativos.

## Deferral

Um Operator deferrable suspende sua execução e registra um trigger assíncrono. O
worker é liberado; quando a condição ocorre, o scheduler volta a enfileirar a
task para concluir. O deployment precisa executar e monitorar pelo menos um
triggerer.

O suporte é específico da implementação. Definir `deferrable=True` em uma classe
que não implementa deferral não cria esse comportamento.

Exemplo com um sensor do provider Amazon:

```python
from datetime import datetime, timezone

from airflow.providers.amazon.aws.sensors.s3 import S3KeySensor
from airflow.sdk import DAG, task


with DAG(
    dag_id="processar_vendas_s3",
    schedule="@daily",
    start_date=datetime(2026, 1, 1, tzinfo=timezone.utc),
    catchup=False,
):

    aguardar_arquivo = S3KeySensor(
        task_id="aguardar_arquivo",
        aws_conn_id="aws_default",
        bucket_name="dados-producao",
        bucket_key="raw//vendas.parquet",
        deferrable=True,
        poke_interval=5 * 60,
        timeout=12 * 60 * 60,
    )

    @task
    def processar():
        processar_arquivo_validado()

    aguardar_arquivo >> processar()
```

As funções e os tempos são placeholders. Antes de usar, confirme a versão do
provider, a existência da Connection, as permissões no bucket e a capacidade do
triggerer.

## Timeout, intervalo e falha

- `poke_interval` controla o intervalo entre verificações;
- `timeout` limita quanto tempo o sensor pode aguardar pela condição;
- `execution_timeout` limita uma execução ou tentativa conforme a estratégia
  usada;
- `soft_fail=True` transforma o timeout do sensor em `skipped`, o que altera o
  fluxo downstream.

Escolha `timeout` a partir do atraso máximo aceito pelo workflow. Escolha o
intervalo a partir da latência necessária e do custo imposto à fonte. Backoff
pode reduzir polling quando a probabilidade de sucesso imediato diminui.

Um sensor concluído indica que sua condição retornou sucesso. Isso não garante
que o dado esteja completo ou semanticamente válido, a menos que a própria
condição faça essa verificação.

## Critério de escolha

Eu começaria verificando se o provider oferece uma implementação deferrable. Se
oferecer, testaria o triggerer sob a concorrência esperada. Sem suporte a
deferral, usaria `reschedule` quando a espera não justificar manter um worker.
Reservaria `poke` para baixa concorrência e espera curta medida no ambiente.

Antes de produção, valide:

- máximo de sensores simultâneos;
- ocupação de worker slots e pools;
- capacidade e alta disponibilidade do triggerer;
- carga de polling sobre a fonte;
- atraso entre evento, detecção e início downstream;
- comportamento de timeout, retry e `soft_fail`;
- recuperação depois da indisponibilidade do scheduler ou triggerer.

## Referências

APACHE AIRFLOW. *Sensors*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/sensors.html](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/sensors.html)

APACHE AIRFLOW. *Deferrable Operators & Triggers*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/deferring.html](https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/deferring.html)

APACHE AIRFLOW PROVIDERS AMAZON. *S3KeySensor*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow-providers-amazon/stable/_api/airflow/providers/amazon/aws/sensors/s3/index.html](https://airflow.apache.org/docs/apache-airflow-providers-amazon/stable/_api/airflow/providers/amazon/aws/sensors/s3/index.html)
