# O papel do XCom

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/data-engineering/apache-airflow/por-que-seu-airflow-pode-estar-lento-o-papel-do-xcom-e-do-banco-de-metadados.html

---

# XCom e banco de metadados: como investigar latência no Airflow
{: .no_toc }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

Uma demora entre tasks não demonstra que o XCom é o gargalo. Scheduler,
executor, pools, fila, inicialização do worker, parsing do DAG, banco de
metadados e dependências externas também participam desse intervalo. XCom entra
na investigação quando há muitos valores, payloads grandes ou operações lentas
no backend usado para armazená-los.

![](/assets/884b913a77ed98e41b204c456704a22a_MD5.png){: .rounded }

## O que o XCom transporta

XCom é o mecanismo de troca de valores pequenos entre task instances. Um retorno
de uma task TaskFlow pode gerar um XCom automaticamente; o mesmo pode ser feito
de forma explícita com push e pull.

No backend padrão, o valor serializado é persistido no banco de metadados. No
Airflow 3, o código executado pelo worker usa a API de execução e não deve acessar
o metastore diretamente. Portanto, “o worker faz uma consulta SQL para cada
pull” não é uma descrição correta da fronteira arquitetural atual, embora o
backend ainda possa terminar no banco.

XCom é adequado para metadados de coordenação, como:

- identificadores e status;
- contagens pequenas;
- nomes de partição;
- URI de um arquivo ou tabela;
- parâmetros necessários à próxima task.

DataFrames, arquivos, modelos e grandes documentos devem ser persistidos em um
armazenamento apropriado. Passe pelo XCom apenas uma referência e os metadados
necessários para validar o artefato.

## Como investigar antes de mudar o backend

Compare timestamps e métricas para separar os tempos de:

1. conclusão da task upstream;
2. decisão e enfileiramento pelo scheduler;
3. espera por pool ou worker;
4. inicialização da task downstream;
5. leitura e desserialização do XCom.

Também verifique:

- quantidade e tamanho serializado dos XComs por DAG Run;
- crescimento e latência do banco de metadados;
- retenção e limpeza de registros antigos;
- latência entre os componentes e seus backends;
- tempo de serialização e desserialização;
- capacidade do executor, do broker e dos pools.

Sem essa separação, mover XComs pode não alterar o gargalo observado.

## Backend de XCom em object storage

O provider `apache-airflow-providers-common-io` oferece o
`XComObjectStorageBackend`. Ele mantém no metastore o valor pequeno ou uma
referência e grava no object storage os valores que excedem o limite configurado.

Exemplo hipotético com S3:

```bash
export AIRFLOW__CORE__XCOM_BACKEND='airflow.providers.common.io.xcom.backend.XComObjectStorageBackend'
export AIRFLOW__COMMON_IO__XCOM_OBJECTSTORAGE_PATH='s3://aws_default@meu-bucket/xcoms/'
export AIRFLOW__COMMON_IO__XCOM_OBJECTSTORAGE_THRESHOLD='1048576'
export AIRFLOW__COMMON_IO__XCOM_OBJECTSTORAGE_COMPRESSION='gzip'
```

Nesse exemplo, o limite é 1 MiB. Ele não é uma recomendação universal: escolha o
valor depois de medir distribuição dos payloads, custo do banco, latência do
object storage e frequência de leitura.

A semântica documentada do threshold é:

| Valor | Comportamento |
|-------|---------------|
| `-1` | mantém os XComs no banco de dados |
| `0` | envia os valores ao object storage |
| número positivo | usa object storage quando o valor excede o limite |

O valor `-1` é o padrão e **não** força envio ao S3. Confundir essa configuração
mantém os payloads no metastore, produzindo o comportamento oposto ao esperado.

O identificador antes de `@` na URI é o `conn_id`; no exemplo,
`aws_default`. Instale versões compatíveis do provider `common-io`, do provider
do armazenamento e de suas dependências usando as constraints correspondentes à
versão do Airflow.

## O que o backend externo não resolve

Object storage aumenta a capacidade disponível para o backend, mas não torna
arbitrariamente grandes os valores adequados para XCom. O payload ainda precisa
ser serializado, escrito, lido e desserializado. Isso adiciona custo, latência e
uma nova dependência operacional.

Também é necessário definir:

- criptografia e controle de acesso do bucket;
- credenciais disponíveis apenas aos componentes necessários;
- retenção e descarte coerentes com o histórico do Airflow;
- comportamento quando o objeto existe, mas a referência foi removida, ou o
  inverso;
- observabilidade de falhas e latência do armazenamento;
- custo de transferência e requisições.

Para um DataFrame, por exemplo, a opção inicial costuma ser gravar Parquet em um
bucket ou tabela e passar URI, partição, schema ou checksum no XCom. Assim, o
artefato tem ciclo de vida explícito e pode ser inspecionado sem depender da
desserialização interna do Airflow.

## Critério de decisão

Mantenha o backend padrão quando os XComs forem pequenos, pouco numerosos e o
metastore estiver dentro dos limites aceitos. Avalie o backend de object storage
quando medições relacionarem volume ou tamanho de XCom à pressão no banco.

Antes da mudança, registre p95 de duração das operações relevantes, tamanho do
metastore e volume de XCom. Repita a medição depois e inclua falha do object
storage no teste. O ganho só está demonstrado se a métrica que motivou a mudança
melhorar sem ultrapassar os limites de confiabilidade e custo.

## Referências

APACHE AIRFLOW. *XComs*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/xcoms.html](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/xcoms.html)

APACHE AIRFLOW. *Public Interface for Airflow 3.0+*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/public-airflow-interface.html](https://airflow.apache.org/docs/apache-airflow/stable/public-airflow-interface.html)

APACHE AIRFLOW. *Object Storage XCom Backend*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow-providers-common-io/stable/xcom_backend.html](https://airflow.apache.org/docs/apache-airflow-providers-common-io/stable/xcom_backend.html)

APACHE AIRFLOW. *Common IO Configuration Reference*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow-providers-common-io/stable/configurations-ref.html](https://airflow.apache.org/docs/apache-airflow-providers-common-io/stable/configurations-ref.html)
