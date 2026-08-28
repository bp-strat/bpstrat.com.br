# Pipelines de Dados

Author: Gilmar Pupo
Canonical: https://www.bpstrat.com.br/docs/data-engineering/pipelines.html

---

# Pipelines de dados
{: .no_toc }

Um pipeline de dados move dados entre fontes e destinos e coordena etapas como extração, validação, transformação e carga. Ele pode operar em lote ou continuamente, usar um único mecanismo ou combinar serviços diferentes.
{: .fs-6 .fw-300 }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

## ETL e ELT

ETL e ELT descrevem a ordem entre transformação e carga no destino analítico principal:

```text
ETL: fonte → extração → transformação → carga → destino
ELT: fonte → extração → carga → destino → transformação
```

- **ETL — Extract, Transform, Load:** os dados são transformados antes da carga no destino.
- **ELT — Extract, Load, Transform:** os dados são carregados no destino antes das transformações analíticas.

Essa definição não determina produto, infraestrutura ou modalidade de execução. ETL pode usar serviços gerenciados e cloud; ELT pode operar em infraestrutura própria. Ambos podem usar uma área de staging, preservar dados brutos, processar cargas incrementais e participar de fluxos batch ou streaming.

## O que a sigla não determina

| Aspecto | Depende de |
|---|---|
| Local físico da transformação | Engine escolhido, acesso aos dados e topologia da plataforma |
| Custo | Compute, armazenamento, transferência, licenças, operação e padrão de uso |
| Flexibilidade | Retenção de dados brutos, contratos, versionamento, lineage e capacidade de reprocessar |
| Desempenho | Volume, formato, particionamento, paralelismo, concorrência e engine |
| Segurança | Controles antes e depois da carga, acesso, criptografia, mascaramento e isolamento |
| Qualidade | Validações, regras, testes, observabilidade e tratamento de falhas |

Por isso, afirmações como “ETL exige infraestrutura própria” ou “ELT é sempre mais flexível e barato” não podem ser concluídas apenas pela ordem das letras.

## Fluxos híbridos

Muitos pipelines transformam parte dos dados antes da carga e outra parte depois:

```text
fonte
  → validação, filtragem ou proteção de dados sensíveis
  → carga no destino
  → padronização, combinação e modelos analíticos
```

Esse arranjo pode ser útil quando determinados campos não podem chegar brutos ao destino, mas a plataforma de destino é adequada para transformações analíticas e reprocessamento. A decisão deve identificar quais regras executam em cada lado; chamar todo o fluxo de ETL ou ELT não substitui essa descrição.

## Critérios de escolha

| Critério | Perguntas para a decisão |
|---|---|
| Volume e crescimento | Quanto é extraído por execução? Qual é a taxa de crescimento? Uma carga completa é viável? |
| Latência | Qual atraso é aceitável? O fluxo será periódico, incremental ou contínuo? |
| Governança | Quais dados podem ser armazenados brutos? Quais controles, retenção e lineage são exigidos? |
| Dados sensíveis | Algum campo precisa ser removido, tokenizado ou mascarado antes de sair da origem ou entrar no destino? |
| Capacidade do destino | O destino suporta as transformações, concorrência e isolamento necessários sem prejudicar outras cargas? |
| Reprocessamento | É necessário reproduzir resultados antigos? Dados brutos, código, parâmetros e versões ficam disponíveis? |
| Fontes e rede | A origem tolera extrações? Há limites de API, janelas, custos de transferência ou requisitos de residência? |
| Operação | Quem responde por falhas, retries, backfills, qualidade, custo e evolução do pipeline? |

### Sinais que favorecem transformar antes da carga

- dados proibidos no destino precisam ser removidos ou protegidos;
- o destino não possui capacidade ou funções adequadas para a transformação;
- o volume pode ser reduzido de forma material antes da transferência;
- formatos e contratos precisam ser validados antes da persistência principal.

Esses sinais favorecem ETL ou uma etapa inicial de um fluxo híbrido. Eles não eliminam a necessidade de observar o dado descartado, lidar com falhas e planejar reprocessamento.

### Sinais que favorecem transformar depois da carga

- o destino oferece capacidade compatível com o processamento necessário;
- preservar dados brutos ou pouco processados facilita auditoria e novas transformações;
- diferentes consumidores precisam derivar modelos próprios da mesma entrada;
- reprocessar no destino é mais simples do que repetir a extração das fontes.

Esses sinais favorecem ELT ou a etapa analítica de um fluxo híbrido. Eles não autorizam carregar dados sensíveis sem controles nem demonstram menor custo por si só.

## Papéis das ferramentas

Ferramentas têm papéis diferentes e podem participar de ETL, ELT ou fluxos híbridos. A escolha de uma delas não classifica o pipeline automaticamente.

| Ferramenta | Capacidade descrita pelo projeto | Decisão que permanece aberta |
|---|---|---|
| Apache Airflow | Define workflows com tarefas e dependências, agenda execuções e acompanha seus estados | Onde e com qual engine cada transformação executa |
| dbt | Compila e executa um grafo de transformações na plataforma de dados, com modelos, testes e documentação | Como os dados chegam à plataforma e quais controles ocorrem antes da carga |
| Apache Spark | Processa dados estruturados com SQL e DataFrames e também oferece processamento de streams | Onde o cluster executa, como os dados são armazenados e em que momento são carregados |
| pandas | Oferece `Series` e `DataFrame` para análise e manipulação tabular em um processo Python | Se a capacidade do ambiente atende ao volume, à latência e à operação necessárias |

Airflow é um orquestrador: ele coordena a ordem e a execução das tarefas, mas não substitui a decisão sobre o engine de transformação ou o destino. Para os guias deste site, consulte [Apache Airflow](/docs/data-engineering/apache-airflow/).

## Checklist mínimo

Antes de implementar, registre:

1. qual é o destino considerado na distinção ETL/ELT;
2. quais dados podem chegar ao destino antes de transformação;
3. onde cada transformação será executada e quem a opera;
4. qual volume, frequência e objetivo de latência são esperados;
5. como cargas incrementais, duplicatas e falhas parciais serão tratadas;
6. quais dados, versões e parâmetros permitem reprocessamento;
7. como qualidade, lineage, custo e freshness serão observados;
8. qual condição indicará que a arquitetura precisa ser revista.

## Referências

- [AWS: What is ETL?](https://aws.amazon.com/what-is/etl/)
- [Apache Airflow: Architecture Overview](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/overview.html)
- [dbt Developer Hub: What is dbt?](https://docs.getdbt.com/docs/introduction)
- [Apache Spark: documentação](https://spark.apache.org/docs/latest/)
- [pandas: Package overview](https://pandas.pydata.org/docs/getting_started/overview.html)
