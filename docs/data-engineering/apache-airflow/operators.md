# Operadores e Hooks

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/data-engineering/apache-airflow/operators.html

---

# Operadores e Hooks no Airflow 3
{: .no_toc }

Esta referência diferencia dois papéis que costumam ser confundidos: um
Operator define uma unidade de execução; um Hook encapsula o acesso a um sistema
externo e normalmente recupera credenciais por uma Connection.
{: .fs-6 .fw-300 }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Antes de copiar os exemplos

Os exemplos consideram Airflow 3 e o provider
`apache-airflow-providers-standard`. Operadores, sensores e hooks adicionais
pertencem a providers instalados separadamente. Fixe versões compatíveis com o
Airflow usado no ambiente.

No Airflow 3, `airflow.sdk` é a interface pública para autoria de DAGs. Imports
legados podem continuar disponíveis durante uma janela de migração, mas novos
DAGs não devem depender deles sem necessidade.

## TaskFlow para código Python

Para funções Python, a documentação recomenda o decorator `@task` em vez do
`PythonOperator` clássico. Este exemplo também mostra branching e Bash dentro de
um DAG válido:

```python
from datetime import datetime, timezone

from airflow.providers.standard.operators.empty import EmptyOperator
from airflow.sdk import dag, get_current_context, task


@dag(
    dag_id="exemplo_operadores",
    schedule="@daily",
    start_date=datetime(2026, 1, 1, tzinfo=timezone.utc),
    catchup=False,
)
def exemplo_operadores():

    @task
    def obter_data_logica() -> str:
        context = get_current_context()
        return context["ds"]

    @task.bash
    def executar_script(data_logica: str) -> str:
        return f"python /scripts/processar.py --date {data_logica}"

    @task.branch()
    def decidir_ramo() -> str:
        context = get_current_context()
        if context["ds"] == "2026-01-01":
            return "tarefa_especial"
        return "tarefa_normal"

    data_logica = obter_data_logica()
    processamento = executar_script(data_logica)
    ramo = decidir_ramo()

    tarefa_especial = EmptyOperator(task_id="tarefa_especial")
    tarefa_normal = EmptyOperator(task_id="tarefa_normal")

    processamento >> ramo >> [tarefa_especial, tarefa_normal]


exemplo_operadores()
```

O valor retornado por `decidir_ramo` precisa corresponder ao `task_id` ou aos
`task_ids` que devem continuar. Os demais ramos são marcados como `skipped`, o
que afeta as trigger rules das tasks que voltam a unir o fluxo.

O comando Bash acima recebe uma data produzida pelo próprio DAG. Não injete
diretamente valores não confiáveis, como parâmetros livres de um trigger, em um
shell command; valide a entrada ou passe-a por variável de ambiente apropriada.

## Quando usar Operators clássicos

Operators continuam úteis quando um provider já implementa a integração, o
template e o comportamento de execução necessários. No Airflow 3, os imports dos
operadores comuns ficam no provider standard:

```python
from airflow.providers.standard.operators.bash import BashOperator
from airflow.providers.standard.operators.python import (
    BranchPythonOperator,
    PythonOperator,
)
```

Prefira o componente do provider quando ele já trata autenticação, paginação,
espera, logs ou semântica de retry do serviço. Uma função Python genérica exige
que essas decisões sejam implementadas e testadas no próprio DAG.

## Hooks e Connections

Hooks oferecem uma interface para sistemas externos. Eles não criam uma task por
si próprios; são usados por Operators ou dentro do código executado por uma
task.

| Hook | Provider | Uso comum |
|------|----------|-----------|
| `S3Hook` | `apache-airflow-providers-amazon` | Objetos no Amazon S3 |
| `PostgresHook` | `apache-airflow-providers-postgres` | Consultas e conexões PostgreSQL |
| `HttpHook` | `apache-airflow-providers-http` | Requisições HTTP |
| `GCSHook` | `apache-airflow-providers-google` | Objetos no Google Cloud Storage |
| `BigQueryHook` | `apache-airflow-providers-google` | Jobs e metadados do BigQuery |

Exemplo de uso dentro de uma task:

```python
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.sdk import task


@task
def contar_pedidos() -> int:
    hook = PostgresHook(postgres_conn_id="warehouse_readonly")
    row = hook.get_first("SELECT count(*) FROM pedidos")
    return int(row[0])
```

A Connection `warehouse_readonly` precisa existir. Use credencial com o menor
privilégio necessário e não registre seu conteúdo nos logs. Para dados grandes,
grave o resultado em armazenamento próprio e retorne apenas metadados ou uma
referência curta.

## Critério de escolha

- Use TaskFlow para lógica Python pequena e específica do workflow.
- Use um Operator de provider quando a integração já estiver implementada e sua
  semântica atender ao caso.
- Use Hooks para encapsular acesso a serviços dentro de uma task ou Operator.
- Crie um Operator próprio quando houver comportamento reutilizável, ciclo de
  vida e testes que justifiquem essa abstração.

Em todos os casos, valide idempotência, timeout, retry, efeitos parciais e
permissões da Connection. A escolha da classe não resolve esses riscos sozinha.

{: .note }
> Para esperas, veja [Sensores — Poke, Reschedule e Deferral](/docs/data-engineering/apache-airflow/sensor-modes.html).

## Referências

APACHE AIRFLOW. *Public Interface for Airflow 3.0+*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/public-airflow-interface.html](https://airflow.apache.org/docs/apache-airflow/stable/public-airflow-interface.html)

APACHE AIRFLOW. *Operators and Hooks Reference*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/operators-and-hooks-ref.html](https://airflow.apache.org/docs/apache-airflow/stable/operators-and-hooks-ref.html)

APACHE AIRFLOW. *PythonOperator*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow-providers-standard/stable/operators/python.html](https://airflow.apache.org/docs/apache-airflow-providers-standard/stable/operators/python.html)

APACHE AIRFLOW. *BashOperator*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow-providers-standard/stable/operators/bash.html](https://airflow.apache.org/docs/apache-airflow-providers-standard/stable/operators/bash.html)
