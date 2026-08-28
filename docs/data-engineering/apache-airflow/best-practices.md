# Melhores Práticas

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/data-engineering/apache-airflow/best-practices.html

---

# Melhores Práticas para DAGs em Produção
{: .no_toc }

Critérios para reduzir duplicação, saída parcial, espera sem limite e exposição
de credenciais em DAGs de produção.
{: .fs-6 .fw-300 }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 1. Idempotência

Projete cada task para que repeti-la com a mesma entrada e o mesmo intervalo
lógico produza o mesmo estado de negócio esperado. Essa propriedade permite que
retries e reprocessamentos convirjam, em vez de acumularem registros ou efeitos
laterais.

{: .important }
> Idempotência reduz o risco de duplicação durante retries e backfills, mas não
> garante um reprocessamento seguro. Versão do código, dados de entrada,
> concorrência e efeitos em sistemas externos também precisam ser controlados.

O exemplo abaixo pressupõe uma restrição `UNIQUE` sobre
`totais_diarios(data_intervalo)`. Para a mesma data e o mesmo total, a segunda
execução mantém o estado de negócio produzido pela primeira:

```python
def carregar_total(data_intervalo, total):
    db.execute(
        """
        INSERT INTO totais_diarios (data_intervalo, total)
        VALUES (%s, %s)
        ON CONFLICT (data_intervalo)
        DO UPDATE SET total = EXCLUDED.total
        """,
        (data_intervalo, total),
    )
```

Na prática:

- leia e escreva partições identificadas pelo intervalo da execução, em vez de
  usar implicitamente o dado “mais recente”;
- use UPSERT, substituição de partição ou escrita atômica quando uma repetição
  não puder criar duplicatas;
- agrupe alterações dependentes em uma transação quando o destino oferecer esse
  recurso;
- associe chamadas externas a uma chave de idempotência ou deduplicação;
- diferencie estado de negócio de metadados operacionais, como horário e número
  da tentativa;
- teste a task duas vezes para o mesmo intervalo e compare registros, arquivos,
  mensagens e demais efeitos observáveis.

Quando o destino não oferece transações ou deduplicação, documente o modo de
falha e implemente reconciliação ou compensação. Marcar a task como concluída no
Airflow não desfaz um efeito externo parcial.

## 2. Atomicidade

Uma task é atomicamente publicável quando termina com toda a saída esperada ou
não deixa uma saída parcial disponível aos consumidores. Fazer “uma coisa” pode
melhorar a compreensão, mas não garante atomicidade.

Padrões possíveis incluem:

- escrever em staging e promover o resultado depois da validação;
- usar transação para alterações que precisam ser confirmadas juntas;
- gravar arquivo temporário e fazer rename ou troca atômica quando o storage
  oferecer essa garantia;
- publicar marcador ou evento de conclusão somente após validar a saída;
- remover ou reconciliar artefatos parciais antes de um retry.

Exemplo conceitual para publicar uma partição preparada em staging:

```sql
BEGIN;

DELETE FROM vendas
WHERE data_intervalo = :data_intervalo;

INSERT INTO vendas (data_intervalo, pedido_id, valor)
SELECT data_intervalo, pedido_id, valor
FROM vendas_staging
WHERE carga_id = :carga_id;

COMMIT;
```

O exemplo depende das garantias transacionais do banco e de uma staging já
validada. Ele não cobre falha durante a extração nem efeitos em outro sistema.

Separar extração, transformação, carga e validação em tasks pode melhorar retry,
observabilidade e isolamento de recursos quando cada fronteira possui um
artefato persistido e verificável. Sem essa persistência, a divisão pode apenas
aumentar transferência de dados e pontos de falha. Escolha a granularidade a
partir da unidade de recuperação, não de uma regra de quantidade de operações.

## 3. Proteja credenciais e secrets

{: .warning }
> Não grave credenciais no código da DAG, em parâmetros versionados, logs ou
> XComs. Use uma **Connection** e controle onde seu valor sensível é armazenado e
> quais componentes podem recuperá-lo.

Connections são o modelo do Airflow para credenciais e configurações de acesso
a serviços externos. Elas podem ser obtidas de:

- um secrets backend externo, como Vault ou o gerenciador de secrets da nuvem;
- variáveis de ambiente no formato `AIRFLOW_CONN_<CONN_ID>`;
- banco de metadados do Airflow.

Um secrets backend é indicado quando a organização precisa centralizar rotação,
auditoria e controle de acesso. Variáveis de ambiente podem ser adequadas quando
o mecanismo de implantação as injeta apenas nos componentes que precisam delas.
O banco de metadados pode ser aceitável em contextos compatíveis com seu modelo
de ameaça, desde que Fernet, permissões, backup e rotação de chaves estejam
configurados e testados.

`Variable` é um armazenamento genérico de configuração. Não a trate como
equivalente a uma Connection apenas porque o valor pode ser criptografado ou
resolvido por um secrets backend. Se uma Variable precisar conter informação
sensível, aplique os mesmos controles de armazenamento, acesso, mascaramento e
rotação.

No Airflow 3, uma task pode recuperar uma Connection pela API pública:

```python
from airflow.sdk import Connection, task


@task
def chamar_servico():
    connection = Connection.get("servico_externo")
    token = connection.password

    # Use o token sem registrá-lo em logs nem retorná-lo por XCom.
    chamar_api(token=token)
```

Quando existir um Hook ou Operator para o serviço, prefira informar o `conn_id`
a esse componente. Assim, a integração recupera a Connection sem espalhar a
manipulação da credencial pelo código da DAG.

## 4. Configurar Timeouts Adequados

Timeouts transformam uma execução excessivamente longa em uma falha observável.
Eles devem refletir o limite operacional do workflow, e não um valor único
aplicado a todas as tasks.

| Parâmetro | Escopo | Decisão necessária |
|-----------|--------|--------------------|
| `execution_timeout` | Cada tentativa de uma task | Quanto tempo uma tentativa pode executar antes de ser interrompida |
| `dagrun_timeout` | DAG Run | Quanto tempo o workflow completo pode permanecer em execução |
| `timeout` de sensor | Espera total do sensor | Quanto tempo a condição externa pode permanecer ausente |

Para definir esses limites:

- use a distribuição histórica de duração, incluindo picos esperados;
- reserve tempo para retries e recuperação dentro do SLO do workflow;
- diferencie processamento lento de espera por uma condição externa;
- confirme se interromper a task deixa efeitos parciais que exigem limpeza ou
  reconciliação;
- gere alerta com contexto suficiente para distinguir timeout, indisponibilidade
  da dependência e falta de capacidade.

O exemplo abaixo é **hipotético**. Ele supõe que o DAG deva terminar em até seis
horas e que uma tentativa normalmente conclua em menos de duas horas. Esses
valores precisam ser substituídos pelos limites observados e acordados para cada
workflow:

```python
from datetime import datetime, timedelta, timezone

from airflow.sdk import DAG, task


with DAG(
    dag_id="meu_dag",
    schedule="@daily",
    start_date=datetime(2026, 1, 1, tzinfo=timezone.utc),
    catchup=False,
    dagrun_timeout=timedelta(hours=6),
) as dag:

    @task(
        execution_timeout=timedelta(hours=2),
        retries=1,
        retry_delay=timedelta(minutes=10),
        retry_exponential_backoff=True,
    )
    def processar():
        ...

    processar()
```

Retries são apropriados para falhas transitórias, como indisponibilidade
temporária ou limitação de taxa. Erros de autenticação, entrada inválida e falhas
determinísticas tendem a repetir o mesmo resultado. Antes de habilitar retries,
confirme que a task é repetível e que uma tentativa anterior não deixou um efeito
externo sem deduplicação ou compensação.

## 5. Sensores: Escolha o Modo Correto

Não existe um limite universal de minutos que determine a escolha. Considere a
duração esperada, a latência tolerada, o número de sensores simultâneos e a
capacidade dos workers, do scheduler e do triggerer.

| Contexto | Opção a avaliar | Limite relevante |
|----------|-----------------|------------------|
| Sensor com implementação deferrable e triggerer operacional | Deferrable | Libera o worker durante a espera, mas transfere trabalho ao triggerer |
| Polling periódico sem suporte a deferral | `reschedule` | Libera o worker entre verificações, com custo de reagendamento |
| Espera curta, baixa concorrência e baixa latência necessária | `poke` | Ocupa um worker slot durante toda a espera |

Para cada sensor:

- verifique primeiro se o provider oferece uma implementação deferrable;
- confirme que o deployment executa e monitora o triggerer antes de ativar
  deferral;
- defina `poke_interval` conforme a latência aceitável e o custo da consulta ao
  sistema externo;
- configure `timeout` para transformar uma espera excessiva em falha observável;
- considere backoff quando a frequência de polling puder diminuir ao longo da
  espera;
- teste a quantidade máxima de sensores simultâneos sem impedir a execução das
  demais tasks.

`deferrable=True` não é um comportamento universal de todo sensor: o efeito
depende da implementação do Operator ou Sensor. Confirme o suporte na versão do
provider utilizada.

Veja o guia completo: [Sensores — Poke, Reschedule e Deferral](/docs/data-engineering/apache-airflow/sensor-modes.html)

---

## Checklist de Produção

- [ ] Retries para o mesmo intervalo não duplicam registros nem efeitos externos
- [ ] Falhas não deixam saída parcial visível aos consumidores
- [ ] Timeouts refletem duração observada, SLO e tempo de recuperação
- [ ] Retries são usados apenas para falhas recuperáveis em tasks repetíveis
- [ ] Sensores não retêm worker slots sem uma decisão explícita
- [ ] Sensores têm intervalo, timeout e capacidade validados
- [ ] Credenciais não estão no código, nos logs nem em XComs
- [ ] Connections sensíveis usam armazenamento e acesso compatíveis com o modelo de ameaça
- [ ] Falhas e atrasos críticos produzem alertas testados
- [ ] `catchup` corresponde à política de processamento histórico do DAG
- [ ] Dependências entre DAGs declaram semântica de evento, espera ou disparo

## Referências

APACHE AIRFLOW. *Best Practices — Airflow 2.10.2*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/2.10.2/best-practices.html](https://airflow.apache.org/docs/apache-airflow/2.10.2/best-practices.html)

APACHE AIRFLOW. *Sensors*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/sensors.html](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/sensors.html)

APACHE AIRFLOW. *Deferrable Operators & Triggers*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/deferring.html](https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/deferring.html)

APACHE AIRFLOW. *Tasks — Timeouts and Retry Policies*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/tasks.html](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/tasks.html)

APACHE AIRFLOW. *Managing Connections*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/howto/connection.html](https://airflow.apache.org/docs/apache-airflow/stable/howto/connection.html)

APACHE AIRFLOW. *Secrets Backend*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/security/secrets/secrets-backend/index.html](https://airflow.apache.org/docs/apache-airflow/stable/security/secrets/secrets-backend/index.html)

APACHE AIRFLOW. *Airflow Security Model*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/security/security_model.html](https://airflow.apache.org/docs/apache-airflow/stable/security/security_model.html)

APACHE AIRFLOW. *Public Interface for Airflow 3.0+*. Disponível em:
[https://airflow.apache.org/docs/apache-airflow/stable/public-airflow-interface.html](https://airflow.apache.org/docs/apache-airflow/stable/public-airflow-interface.html)
